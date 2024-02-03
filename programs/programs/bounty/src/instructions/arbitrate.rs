use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;
// use crate::errors::*;
// use crate::events::*;

pub fn arbitrate(ctx: Context<ArbitrateEscrow>, amount: u64) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    let creator_token_amount = ctx.accounts.escrow_token_account.amount - amount;

    if amount > 0 {
        let pay_worker = (
            &ctx.accounts.mint,
            &ctx.accounts.escrow_token_account,
            &ctx.accounts.worker_token_account,
            amount,
        );

        let _ = escrow.release(pay_worker, &ctx.accounts.payer, &ctx.accounts.token_program);
    }

    if creator_token_amount > 0 {
        let pay_creator = (
            &ctx.accounts.mint,
            &ctx.accounts.escrow_token_account,
            &ctx.accounts.creator_token_account,
            creator_token_amount,
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
        associated_token::authority = escrow,
    )]
    pub escrow_token_account: Account<'info, token::TokenAccount>,
    #[account(address = escrow.creator)]
    pub creator: UncheckedAccount<'info>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = creator
    )]
    pub creator_token_account: Account<'info, token::TokenAccount>,
    #[account(address = escrow.worker)]
    pub worker: UncheckedAccount<'info>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = worker
    )]
    pub worker_token_account: Account<'info, token::TokenAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, token::Token>,
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
