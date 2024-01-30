use crate::{instruction::Release, state::*};
use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

// Rewrite this to arbitrate function

pub fn arbitrate(ctx: Context<Escrow>, release: Release) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    //
}

#[derive(Accounts)]
pub struct ArbitrateEscrow<'info> {
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
    /// The payer's token account for the asset
    /// being deposited into the pool
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = payer,
    )]
    pub payer_token_account: Account<'info, token::TokenAccount>,
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
