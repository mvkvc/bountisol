use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;
use crate::events::*;

pub fn release(ctx: Context<ReleaseBounty>, amount: u64) -> Result<()> {
    let bounty = &mut ctx.accounts.bounty;

    let transaction = (
        &ctx.accounts.mint,
        &ctx.accounts.bounty_token_account,
        &ctx.accounts.worker_token_account,
        amount,
    );

    bounty.release(
        transaction,
        &ctx.accounts.payer,
        &ctx.accounts.token_program,
    );

    emit!(BountyReleased {
        address: ctx.accounts.bounty.key(),
        to: ctx.accounts.worker.key(),
        token: ctx.accounts.mint.key(),
        amount: amount,
    });

    Ok(())
}

#[derive(Accounts)]
pub struct ReleaseBounty<'info> {
    #[account(
        mut,
        seeds = [Bounty::SEED_PREFIX.as_bytes()],
        bump = bounty.bump,
    )]
    pub bounty: Account<'info, Bounty>,
    pub mint: Account<'info, token::Mint>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = bounty
    )]
    pub bounty_token_account: Account<'info, token::TokenAccount>,
    #[account(address = bounty.worker)]
    pub worker: UncheckedAccount<'info>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = worker
    )]
    pub worker_token_account: Account<'info, token::TokenAccount>,
    #[account(mut, address = bounty.creator)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, token::Token>,
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
