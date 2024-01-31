use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;
use crate::errors::*;
use crate::events::*;

pub fn arbitrate(ctx: Context<ArbitrateEscrow>, amount: u64) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    if *ctx.accounts.payer.key != escrow.creator {
        return Err(EscrowProgramError::InvalidPayerError.into());
    }

    if escrow.deadline > Clock::get()?.unix_timestamp.try_into().unwrap() {
        return Err(EscrowProgramError::InvalidTimeError.into());
    }

    let creator_token_amount = ctx.accounts.escrow_token_account.amount - amount;

    if amount > 0 {
        let pay_worker = (
            &ctx.accounts.mint,
            &ctx.accounts.escrow_token_account,
            &ctx.accounts.worker_token_account,
            amount
        );

        let _ = escrow.release(
            pay_worker,
            &ctx.accounts.payer,
            &ctx.accounts.token_program,
        );
    }

    if creator_token_amount > 0 {
        let pay_creator = (
            &ctx.accounts.mint,
            &ctx.accounts.escrow_token_account,
            &ctx.accounts.creator_token_account,
            creator_token_amount
        );

        let _ = escrow.release(
            pay_creator,
            &ctx.accounts.payer,
            &ctx.accounts.token_program,
        );
    }

    Ok(())
}

#[derive(Accounts)]
pub struct ArbitrateEscrow<'info> {
    // Escrow
    #[account(
        init,
        space = Escrow::SPACE,
        payer = payer,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub escrow: Account<'info, Escrow>,
    /// The mint account for the asset being deposited into the pool
    pub mint: Account<'info, token::Mint>,
    /// The Escrow's token account for the asset being deposited into
    /// the pool
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = escrow,
    )]
    pub escrow_token_account: Account<'info, token::TokenAccount>,
    /// The payer's token account for the asset
    /// being deposited into the pool
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = payer,
    )]
    pub payer_token_account: Account<'info, token::TokenAccount>,
    /// CHECK: This is not dangerous because we don't read or write from this account
    pub creator: AccountInfo<'info>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = creator
    )]
    pub creator_token_account: Account<'info, token::TokenAccount>,
    /// CHECK: This is not dangerous because we don't read or write from this account
    pub worker: AccountInfo<'info>,
    #[account(
        mut,
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
