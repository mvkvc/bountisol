pub mod errors;
pub mod instructions;
pub mod state;

use anchor_lang::prelude::*;
use instructions::*;

declare_id!("EkcjDCwoF7ffZox75WTqqtkirDEWdcNF4oUjigqEEmut");

#[program]
pub mod escrow {
    use super::*;

    pub fn create(
        ctx: Context<CreateEscrow>,
        amount: u64,
        worker: Pubkey,
        arbitrator: Pubkey,
        hours_to_expiration: u64,
    ) -> Result<()> {
        instructions::create(
            ctx,
            amount,
            worker,
            arbitrator,
            hours_to_expiration,
        )
    }

    pub fn fund(ctx: Context<FundEscrow>, amount: u64) -> Result<()> {
        instructions::fund(ctx, amount)
    }

    pub fn release(ctx: Context<ReleaseEscrow>, release: Release) -> Result<()> {
        instructions::release(ctx, release)
    }

    pub fn dispute(ctx: Context<DisputeEscrow>) -> Result<()> {
        instructions::dispute(ctx)
    }

    pub fn arbitrate(ctx: Context<ArbitrateEscrow>, release: Release) -> Result<()> {
        instructions::arbitrate(ctx, release)
    }
}
