use anchor_lang::{prelude::*, system_program};
use anchor_spl::token::{transfer, Mint, Token, TokenAccount, Transfer};

#[account]
pub struct Bounty {
    pub bump: u8,
    pub assets: Vec<Pubkey>,
    pub arbitrator: Pubkey,
    pub refundee: Pubkey,
    pub payees: Option<Pubkey>,
}

impl Escrow {
    pub const SEED_PREFIX: &'static str = "bountisol_ot escrow";
    // https://book.anchor-lang.com/anchor_references/space.html
    //  disc + u8 + empty vec + pubkey + empty vec
    pub const SPACE: usize = 8 + 1 + 4 + 32 + 33;

    pub fn new(bump: u8, admin: Pubkey) -> Self {
        Self {
            bump,
            assets: vec![],
            admin,
            recipient: None,
        }
    }
}

pub trait EscrowAccount<'info> {
    fn check_asset_key(&self, key: &Pubkey) -> Result<()>;
    fn check_recipient(&self, key: &Pubkey) -> Result<()>;
    fn add_asset(
        &mut self,
        key: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;
    fn add_recipient(
        &mut self,
        recipient: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;
    fn realloc(
        &mut self,
        space_to_add: usize,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()>;
    fn fund(
        &mut self,
        transaction: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        system_program: &Program<'info, System>,
        token_program: &Program<'info, Token>,
    ) -> Result<()>;
    fn assign(&mut self, worker: Pubkey, authority: &Signer<'info>) -> Result<()>;
    fn release(
        &mut self,
        transaction: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        token_program: &Program<'info, Token>,
    ) -> Result<()>;
}

impl<'info> EscrowAccount<'info> for Account<'info, Escrow> {
    fn check_asset_key(&self, key: &Pubkey) -> Result<()> {
        if self.assets.contains(key) {
            Ok(())
        } else {
            Err(EscrowError::InvalidAssetKey.into())
        }
    }
    fn check_recipient(&self, key: &Pubkey) -> Result<()> {
        if self.recipients.contains(key) {
            Err(EscrowError::DuplicateRecipient.into())
        } else {
            Ok(())
        }
    }
    fn add_asset(
        &mut self,
        key: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        match self.check_asset_key(&key) {
            Ok(()) => (),
            Err(_) => {
                self.realloc(32, payer, system_program)?;
                self.assets.push(key)
            }
        };
        Ok(())
    }
    fn add_recipient(
        &mut self,
        recipient: Pubkey,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        match self.check_recipient(&recipient) {
            Ok(()) => (),
            Err(_) => {
                self.realloc(32, payer, system_program)?;
                self.assets.push(recipient)
            }
        };
        Ok(())
    }
    /// Reallocates the account's size to accommodate for changes in the data
    /// size. This is used in this program to reallocate the Liquidity Pool's
    /// account when it's vector of mint addresses (`Vec<Pubkey>`) is increased
    /// in size by pushing one `Pubkey` into the vector
    fn realloc(
        &mut self,
        space_to_add: usize,
        payer: &Signer<'info>,
        system_program: &Program<'info, System>,
    ) -> Result<()> {
        let account_info = self.to_account_info();
        let new_account_size = account_info.data_len() + space_to_add;

        // Determine additional rent required
        let lamports_required = (Rent::get()?).minimum_balance(new_account_size);
        let additional_rent_to_fund = lamports_required - account_info.lamports();

        // Perform transfer of additional rent
        system_program::transfer(
            CpiContext::new(
                system_program.to_account_info(),
                system_program::Transfer {
                    from: payer.to_account_info(),
                    to: account_info.clone(),
                },
            ),
            additional_rent_to_fund,
        )?;

        // Reallocate the account
        account_info.realloc(new_account_size, false)?;
        Ok(())
    }

    fn assign(&mut self, worker: Pubkey, authority: &Signer<'info>) -> Result<()> {
        if authority.key() != self.creator {
            return Err(EscrowError::InvalidPayer.into());
        }

        if self.worker.is_some() {
            return Err(EscrowError::AlreadyAssigned.into());
        }

        self.worker = Some(worker);
        Ok(())
    }

    fn fund(
        &mut self,
        deposit: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        system_program: &Program<'info, System>,
        token_program: &Program<'info, Token>,
    ) -> Result<()> {
        let (mint, from, to, amount) = deposit;
        self.add_asset(mint.key(), authority, system_program)?;
        process_transfer_to_escrow(from, to, amount, authority, token_program)?;
        Ok(())
    }

    fn release(
        &mut self,
        pay: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        _authority: &Signer<'info>,
        token_program: &Program<'info, Token>,
    ) -> Result<()> {
        // (From, To)
        let (pay_mint, payer_pay, pool_pay, pay_amount) = pay;
        self.check_asset_key(&pay_mint.key())?;

        // Process the release
        if pay_amount == 0 {
            return Err(EscrowError::InvalidAmount.into());
        } else {
            process_transfer_from_escrow(pool_pay, payer_pay, pay_amount, self, token_program)?;
        }

        Ok(())
    }
    fn dispute(&mut self, authority: &Signer<'info>) -> Result<()> {
        if self.disputed {
            return Err(EscrowError::AlreadyDisputed.into());
        }

        let current_unix = Clock::get()?.unix_timestamp.try_into().unwrap();

        if self.deadline < current_unix {
            return Err(EscrowError::BeforeDeadline.into());
        }

        self.disputed = true;
        Ok(())
    }
}

/// Process a transfer from one the payer's token account to the
/// escrow's token account using a CPI
fn process_transfer_to_escrow<'info>(
    from: &Account<'info, TokenAccount>,
    to: &Account<'info, TokenAccount>,
    amount: u64,
    authority: &Signer<'info>,
    token_program: &Program<'info, Token>,
) -> Result<()> {
    transfer(
        CpiContext::new(
            token_program.to_account_info(),
            Transfer {
                from: from.to_account_info(),
                to: to.to_account_info(),
                authority: authority.to_account_info(),
            },
        ),
        amount,
    )
}

/// Process a transfer from the escrow's token account to the
/// payer's token account using a CPI with signer seeds
fn process_transfer_from_escrow<'info>(
    from: &Account<'info, TokenAccount>,
    to: &Account<'info, TokenAccount>,
    amount: u64,
    escrow: &Account<'info, Escrow>,
    token_program: &Program<'info, Token>,
) -> Result<()> {
    transfer(
        CpiContext::new_with_signer(
            token_program.to_account_info(),
            Transfer {
                from: from.to_account_info(),
                to: to.to_account_info(),
                authority: escrow.to_account_info(),
            },
            &[&[Escrow::SEED_PREFIX.as_bytes(), &[escrow.bump]]],
        ),
        amount,
    )
}
