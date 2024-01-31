use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;
use crate::errors::*;

pub fn release(ctx: Context<ReleaseEscrow>) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    if *ctx.accounts.payer.key != escrow.creator {
        // The Payer is not the Escrow creator
        return Err(EscrowProgramError::InvalidPayerError.into());
    }

    if *ctx.accounts.worker.key != escrow.worker {
        // The Worker is not the Escrow worker
        return Err(EscrowProgramError::InvalidWorkerError.into());
    }

    let pay = (
        &ctx.accounts.mint,
        &ctx.accounts.escrow_token_account,
        &ctx.accounts.worker_token_account,
        ctx.accounts.escrow_token_account.amount,
    );

    let _ = escrow.release(pay, &ctx.accounts.payer, &ctx.accounts.token_program);

    Ok(())
}

#[derive(Accounts)]
pub struct ReleaseEscrow<'info> {
    // Escrow
    #[account(
        init,
        space = Escrow::SPACE,
        payer = payer,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub escrow: Account<'info, Escrow>,
    // Worker (not signer only stored as pubkey in escrow var)
    /// The mint account for the asset being deposited into the pool
    pub mint: Account<'info, token::Mint>,
    /// The Escrow's token account for the asset being deposited into
    /// the pool
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = escrow
    )]
    pub escrow_token_account: Account<'info, token::TokenAccount>,
    // Get worker account
    #[account(mut)]
    pub worker: AccountInfo<'info>,

    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = worker
    )]
    pub worker_token_account: Account<'info, token::TokenAccount>,
    // Payer
    #[account(mut)]
    pub payer: Signer<'info>,
    /// System Program: Required for creating the Escrow's token account
    /// for the asset being deposited into the pool
    pub system_program: Program<'info, System>,
    /// Token Program: Required for transferring the assets from the Escrow
    /// Provider's token account into the Escrow's token account
    pub token_program: Program<'info, token::Token>,
    /// Associated Token Program: Required for creating the Escrow's
    /// token account for the asset being deposited into the pool
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
