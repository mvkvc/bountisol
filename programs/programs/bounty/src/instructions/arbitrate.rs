use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::events::*;
use crate::state::*;

pub fn arbitrate(ctx: Context<ArbitrateBounty>, amount: u64) -> Result<()> {
    let bounty = &mut ctx.accounts.bounty;

    let tx = (
        &ctx.accounts.mint,
        &ctx.accounts.bounty_token_account,
        &ctx.accounts.worker_token_account,
        amount,
    );

    match bounty.release(tx, &ctx.accounts.token_program) {
        Ok(_) => {
            emit!(BountyArbitrated {
                address: ctx.accounts.bounty.key(),
                to: ctx.accounts.worker.key(),
                token: ctx.accounts.mint.key(),
                amount: amount,
            });
            Ok(())
        }
        Err(err) => {
            return Err(err);
        }
    }
}

#[derive(Accounts)]
pub struct ArbitrateBounty<'info> {
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
        associated_token::authority = bounty,
    )]
    pub bounty_token_account: Account<'info, token::TokenAccount>,
    #[account(address = bounty.admin)]
    pub creator: UncheckedAccount<'info>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = creator
    )]
    pub creator_token_account: Account<'info, token::TokenAccount>,
    #[account(constraint = bounty.workers.contains(&worker.key()))]
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
