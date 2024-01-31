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
        token: Pubkey,
        worker: Pubkey,
        arbitrator: Pubkey,
        deadline: u64,
    ) -> Result<()> {
        instructions::create(ctx, amount, token, worker, arbitrator, deadline)
    }

    pub fn fund(ctx: Context<FundEscrow>, amount: u64) -> Result<()> {
        instructions::fund(ctx, amount)
    }

    pub fn release(ctx: Context<ReleaseEscrow>) -> Result<()> {
        instructions::release(ctx)
    }

    pub fn arbitrate(ctx: Context<ArbitrateEscrow>, amount: u64) -> Result<()> {
        instructions::arbitrate(ctx, amount)
    }
}
