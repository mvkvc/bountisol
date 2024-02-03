use anchor_lang::prelude::*;

use crate::state::*;

pub fn assign(ctx: Context<AssignEscrow>, worker: Pubkey) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    escrow.assign(worker, &ctx.accounts.payer)
}

#[derive(Accounts)]
pub struct AssignEscrow<'info> {
    #[account(
        mut,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump = escrow.bump,
    )]
    pub escrow: Account<'info, Escrow>,
    #[account(mut, address = escrow.creator)]
    pub payer: Signer<'info>,
}
