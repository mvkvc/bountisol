use anchor_lang::prelude::*;

use crate::state::*;
use crate::events::*;

pub fn create(
    ctx: Context<CreateBounty>,
    deadline_work: u64,
    deadline_dispute: u64,
    admin: Pubkey
) -> Result<()> {
    ctx.accounts.bounty.set_inner(Bounty::new(
        ctx.bumps.bounty,
        deadline_work,
        deadline_dispute,
        admin,
        ctx.accounts.payer.key()
    ));

    emit!(BountyCreated {
        address: ctx.accounts.bounty.key(),
        bump: ctx.bumps.bounty,
        deadline_work: deadline_work,
        deadline_dispute: deadline_dispute,
        admin: admin,
        creator: ctx.accounts.payer.key()
    });

    Ok(())
}

#[derive(Accounts)]
pub struct CreateBounty<'info> {
    #[account(
        init,
        space = Bounty::SPACE,
        payer = payer,
        seeds = [Bounty::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub bounty: Account<'info, Bounty>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
}
