use anchor_lang::prelude::*;
use anchor_spl::token::{self, Token, TokenAccount, Transfer as SplTransfer};
use solana_program::system_instruction;

declare_id!("72xay1vadtYKWM7BxSdXy7LQSCj3MRv8FsgFy4AmeSFz");

// https://solanacookbook.com/references/programs.html#how-to-transfer-sol-in-a-program

#[program]
pub mod transferrer {
    use anchor_lang::solana_program::entrypoint::ProgramResult;

    use super::*;

    pub fn initialize(ctx: Context<Initialize>, owner: Pubkey, fee: u8) -> ProgramResult {
        let transferrer = &mut ctx.accounts.transferrer;
        transferrer.owner = owner;
        //  0-100
        transferrer.fee = fee;
        Ok(())
    }

    pub fn transfer_lamports(ctx: Context<TransferLamports>, amount: u64) -> ProgramResult {
        let from_account = &ctx.accounts.from;
        let to_account = &ctx.accounts.to;

        // Check the multiplication
        let amount_fee = ctx.accounts.transferrer.fee * amount / 100;
        let amount_transfer = amount - amount_fee;

        // Transfer fee amount to owner address
        let transfer_instruction_fee = system_instruction::transfer(from_account.key, &ctx.accounts.transferrer.owner, amount_fee);

        anchor_lang::solana_program::program::invoke_signed(
            &transfer_instruction_fee,
            &[
                from_account.to_account_info(),
                // HELP HERE
                &ctx.accounts.transferrer.owner.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
            ],
            &[],
        )?;

        let transfer_instruction_transfer = system_instruction::transfer(from_account.key, to_account.key, amount_transfer);

        anchor_lang::solana_program::program::invoke_signed(
            &transfer_instruction_transfer,
            &[
                from_account.to_account_info(),
                to_account.clone(),
                ctx.accounts.system_program.to_account_info(),
            ],
            &[],
        )?;

        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    // Is the space correct
    #[account(init, payer = user, space = 8 + 8)]
    pub transferrer: Account<'info, Transferrer>,
    #[account(mut)]
    pub user: Signer<'info>,
    pub system_program: Program<'info, System>,
}

#[derive(Accounts)]
pub struct TransferLamports<'info> {
    #[account(mut)]
    pub transferrer: Account<'info, Transferrer>,
    #[account(mut)]
    pub from: Signer<'info>,
    #[account(mut)]
    pub to: AccountInfo<'info>,
    pub system_program: Program<'info, System>,
}

#[account]
pub struct Transferrer {
    pub owner: Pubkey,
    pub fee: u64
}
