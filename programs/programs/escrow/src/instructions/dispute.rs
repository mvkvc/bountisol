use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;
use crate::errors::*;
// use crate::events::*;

pub fn dispute(ctx: Context<Escrow>) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    let current_unix = Clock::get()?.unix_timestamp.try_into().unwrap();

    if escrow.deadline < current_unix {
        return Err(EscrowError::BeforeDeadline.into());
    }

    escrow.dispute(&ctx.accounts.payer)
}

#[derive(Accounts)]
pub struct DisputeEscrow<'info> {
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
}
