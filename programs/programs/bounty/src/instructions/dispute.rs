use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;

pub fn dispute(ctx: Context<Escrow>) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    escrow.dispute(&ctx.accounts.payer)
}

#[derive(Accounts)]
pub struct DisputeEscrow<'info> {
    #[account(
        mut,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump = escrow.bump,
    )]
    pub escrow: Account<'info, Escrow>,
    #[account(mut, address = escrow.worker)]
    pub payer: Signer<'info>,
}
