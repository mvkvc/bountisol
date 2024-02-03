use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;

pub fn release(ctx: Context<ReleaseEscrow>) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    if escrow.disputed {
        return Err(ErrorCode::Disputed.into());
    }

    let transaction = (
        &ctx.accounts.mint,
        &ctx.accounts.escrow_token_account,
        &ctx.accounts.worker_token_account,
        ctx.accounts.escrow_token_account.amount,
    );

    escrow.release(
        transaction,
        &ctx.accounts.payer,
        &ctx.accounts.token_program,
    )
}

#[derive(Accounts)]
pub struct ReleaseEscrow<'info> {
    #[account(
        mut,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump = escrow.bump,
    )]
    pub escrow: Account<'info, Escrow>,
    pub mint: Account<'info, token::Mint>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = escrow
    )]
    pub escrow_token_account: Account<'info, token::TokenAccount>,
    #[account(address = escrow.worker)]
    pub worker: UncheckedAccount<'info>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = worker
    )]
    pub worker_token_account: Account<'info, token::TokenAccount>,
    #[account(mut, address = escrow.creator)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, token::Token>,
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
