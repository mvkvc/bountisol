use anchor_lang::prelude::*;
use anchor_spl::{associated_token, token};

use crate::state::*;

pub fn fund(ctx: Context<FundEscrow>, amount: u64) -> Result<()> {
    let escrow = &mut ctx.accounts.escrow;

    let transaction = (
        &ctx.accounts.mint,
        &ctx.accounts.payer_token_account,
        &ctx.accounts.escrow_token_account,
        amount,
    );

    escrow.fund(
        transaction,
        &ctx.accounts.payer,
        &ctx.accounts.system_program,
        &ctx.accounts.token_program,
    )
}

#[derive(Accounts)]
pub struct FundEscrow<'info> {
    #[account(
        mut,
        seeds = [Escrow::SEED_PREFIX.as_bytes()],
        bump = escrow.bump,
    )]
    pub escrow: Account<'info, Escrow>,
    pub mint: Account<'info, token::Mint>,
    #[account(
        init_if_needed,
        payer = payer,
        associated_token::mint = mint,
        associated_token::authority = escrow,
    )]
    pub escrow_token_account: Account<'info, token::TokenAccount>,
    #[account(
        mut,
        associated_token::mint = mint,
        associated_token::authority = payer,
    )]
    pub payer_token_account: Account<'info, token::TokenAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    pub system_program: Program<'info, System>,
    pub token_program: Program<'info, token::Token>,
    pub associated_token_program: Program<'info, associated_token::AssociatedToken>,
}
