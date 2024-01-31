use anchor_lang::prelude::*;

use crate::state::*;
use crate::errors::*;
use crate::events::*;

pub fn create(
    ctx: Context<CreateEscrow>,
    amount: u64,
    token: Pubkey,
    worker: Pubkey,
    arbitrator: Pubkey,
    deadline: u64
) -> Result<()> {
    // `set_inner` used to replace the account with the new state
    ctx.accounts.escrow.set_inner(Escrow::new(
        // Bump
        ctx.bumps.escrow,
        amount,
        token,
        ctx.accounts.payer.key(),
        worker,
        arbitrator,
        deadline
    ));


    Ok(())
}

#[derive(Accounts)]
pub struct CreateEscrow<'info> {
    // Escrow
    #[account(
        init,
        space = Escrow::SPACE,
        payer = payer,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub escrow: Account<'info, Escrow>,
    /// Rent payer
    #[account(mut)]
    pub payer: Signer<'info>,
    /// System Program: Required for creating the Escrow
    pub system_program: Program<'info, System>,
}
