use anchor_lang::prelude::*;

use crate::state::*;
use crate::events::*;

pub fn assign(ctx: Context<AssignBounty>, worker: Pubkey) -> Result<()> {
    let bounty = &mut ctx.accounts.bounty;

    bounty.assign(worker, &ctx.accounts.payer);

    emit!(BountyAssigned {
        address: ctx.accounts.bounty.key(),
        worker: worker,
    });

    Ok(())
}

#[derive(Accounts)]
pub struct AssignBounty<'info> {
    #[account(
        mut,
        seeds = [Bounty::SEED_PREFIX.as_bytes()],
        bump = bounty.bump,
    )]
    pub bounty: Account<'info, Bounty>,
    #[account(mut, address = bounty.creator)]
    pub payer: Signer<'info>,
}
