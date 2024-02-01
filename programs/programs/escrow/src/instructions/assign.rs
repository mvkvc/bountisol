use anchor_lang::prelude::*;

use crate::state::*;
// use crate::errors::*;
// use crate::events::*;

pub fn assign(
    ctx: Context<AssignEscrow>,
    worker: Pubkey,
) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    escrow.assign(
        worker,
        ctx.accounts.payer,
    );
}

#[derive(Accounts)]
pub struct CreateEscrow<'info> {
    #[account(
        init,
        space = Escrow::SPACE,
        payer = payer,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub escrow: Account<'info, Escrow>,
    #[account(mut, address = escrow.creator)]
    pub payer: Signer<'info>,
}
