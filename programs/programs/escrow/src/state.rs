use anchor_lang::{prelude::*, system_program};
use anchor_spl::token::{transfer, Mint, Token, TokenAccount, Transfer};

use crate::errors::EscrowProgramError;

#[account]
pub struct Escrow {
    pub bump: u8,
    pub assets: Vec<Pubkey>,
    pub amount: u64,
    pub token: Pubkey,
    pub creator: Pubkey,
    pub worker: Pubkey,
    pub arbitrator: Pubkey,
    pub deadline: u64
}

impl Escrow {
    pub const SEED_PREFIX: &'static str = "escrow";
    pub const SPACE: usize = 8 + 4 + 1;

    pub fn new(
        bump: u8,
        amount: u64,
        token: Pubkey,
        creator: Pubkey,
        worker: Pubkey,
        arbitrator: Pubkey,
        deadline: u64
    ) -> Self {
        Self {
            bump,
            assets: vec![],
            amount,
            token,
            creator,
            worker,
            arbitrator,
            deadline,
        }
    }
}

pub trait EscrowAccount<'info>{
    fn check_asset_key(&self, key: &Pubkey) -> Result<()>;
    fn add_asset(
        &mut self,
        key: Pubkey,
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
        deposit: (
            &Account<'info, Mint>,
            &Account<'info, TokenAccount>,
            &Account<'info, TokenAccount>,
            u64,
        ),
        authority: &Signer<'info>,
        system_program: &Program<'info, System>,
        token_program: &Program<'info, Token>,
    ) -> Result<()>;
    fn release(
        &mut self,
        withdraw: (
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
    /// Validates an asset's key is present in the Liquidity Pool's list of mint
    /// addresses, and throws an error if it is not
    fn check_asset_key(&self, key: &Pubkey) -> Result<()> {
        if self.assets.contains(key) {
            Ok(())
        } else {
            Err(EscrowProgramError::InvalidAssetKey.into())
        }
    }

    /// Adds an asset to the Liquidity Pool's list of mint addresses if it does
    /// not already exist in the list
    ///
    /// if the mint address is added, this will require reallocation of the
    /// account's size since the vector will be increasing by one `Pubkey`,
    /// which has a size of 32 bytes
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
            Err(EscrowProgramError::InvalidAmountError.into())
        } else {
            process_transfer_from_escrow(pool_pay, payer_pay, pay_amount, self, token_program)?;
            Ok(())
        }
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
