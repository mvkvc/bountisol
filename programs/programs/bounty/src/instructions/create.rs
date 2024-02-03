use anchor_lang::prelude::*;

use crate::state::*;

pub fn create(
    ctx: Context<CreateEscrow>,
    token: Pubkey,
    amount: u64,
    deadline: u64,
    admin: Pubkey
) -> Result<()> {
    ctx.accounts.escrow.set_inner(Escrow::new(
        ctx.bumps.escrow,
        ctx.accounts.payer.key(),
        arbitrator,
        deadline,
        requirements,
    ));

    Ok(())
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
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}
