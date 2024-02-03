pub mod errors;
pub mod events;
pub mod instructions;
pub mod state;

use anchor_lang::prelude::*;
use instructions::*;

declare_id!("EkcjDCwoF7ffZox75WTqqtkirDEWdcNF4oUjigqEEmut");

#[program]
pub mod bounty {
    use super::*;

    pub fn create(
        ctx: Context<CreateBounty>,
        deadline: u64,
        admin: Pubkey
    ) -> Result<()> {
        instructions::create(ctx, admin)
    }

    pub fn fund(ctx: Context<FundBounty>, amount: u64) -> Result<()> {
        instructions::fund(ctx, amount)
    }

    pub fn release(ctx: Context<ReleaseBounty>, amount: u64) -> Result<()> {
        instructions::release(ctx, amount)
    }

    pub fn arbitrate(ctx: Context<ReleaseAdminBounty>, amount: u64) -> Result<()> {
        instructions::arbitrate(ctx, amount)
    }

    pub fn reclaim(ctx: Context<ReclaimBounty>, amount: u64) -> Result<()> {
        instructions::reclaim(ctx, amount)
    }
}
