use crate::state::*;
use anchor_lang::prelude::*;

pub fn create(
    ctx: Context<Create>,
    amount: u64,
    token: Pubkey,
    worker: Pubkey,
    arbitrator: Pubkey,
) -> Result<()> {
    // `set_inner` used to replace the account with the new state
    ctx.accounts.escrow.set_inner(Escrow::new(
        *ctx.bumps,
        amount,
        // Ensure the token is supported
        mint_account,
        worker,
        arbitrator
            .get("escrow")
            .expect("Failed to fetch bump for `pool`"),
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