use crate::state::*;
use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

#[derive(AnchorSerialize, AnchorDeserialize, Debug)]
pub enum Release {
    Partial,
    Full,
}

pub fn release(ctx: Context<ReleaseEscrow>, release: Release) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;
    let worker = escrow.worker;
    let time = Clock::get()?.unix_timestamp;
    let hours_to_expiration = escrow.hours_to_expiration;
    let expiration = hours_to_expiration * 60 * 60;

    if time > escrow.expiration {
        // Escrow has expired
        return Err(ErrorCode::EscrowExpired.into());
    }

    match release {
        Partial => {
            // Partial release
        }
        Full => {
            // Full release
        }
    }

    //
}

#[derive(Accounts)]
pub struct ReleaseEscrow<'info> {
    // Escrow
    #[account(
        init,
        space = Escrow::SPACE,
        payer = payer,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump,
    )]
    pub escrow: Account<'info, Escrow>,
    /// The mint account for the asset being deposited into the pool
    pub mint: Account<'info, token::Mint>,
    /// The Escrow's token account for the asset being deposited into
    /// the pool
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = pool,
    )]
    pub pool_token_account: Account<'info, token::TokenAccount>,
    // Payer
    #[account(mut)]
    pub payer: Signer<'info>,
    /// System Program: Required for creating the Escrow's token account
    /// for the asset being deposited into the pool
    pub system_program: Program<'info, System>,
    /// Token Program: Required for transferring the assets from the Escrow
    /// Provider's token account into the Escrow's token account
    pub token_program: Program<'info, token::Token>,
    /// Associated Token Program: Required for creating the Escrow's
    /// token account for the asset being deposited into the pool
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
