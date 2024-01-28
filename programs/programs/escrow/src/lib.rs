use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token, TokenAccount};
// use borsh::{BorshDeserialize, BorshSerialize};

declare_id!("EkcjDCwoF7ffZox75WTqqtkirDEWdcNF4oUjigqEEmut");

#[program]
pub mod escrow {
    use super::*;

    pub fn initialize(
        ctx: Context<Initialize>,
        amount: u64,
        fee_percent: u64,
        counterparty: Pubkey,
        arbitrator: Pubkey,
    ) -> Result<()> {
        let config_account = &mut ctx.accounts.config;
        config_account.counterparty = counterparty;
        config_account.arbitrator = arbitrator;

        anchor_spl::token::transfer(
            CpiContext::new(
                ctx.accounts.token_program.to_account_info(),
                anchor_spl::token::Transfer {
                    from: ctx.accounts.signer_tokens.to_account_info(),
                    to: ctx.accounts.escrow_tokens.to_account_info(),
                    authority: ctx.accounts.signer.to_account_info(),
                },
            ),
            amount,
        )?;

        Ok(())
    }

    pub fn evidence(
        ctx: Context<Evidence>,
        hash: String
    ) -> Result<()> {
        let caller = ctx.accounts.signer.key();
        let config = &ctx.accounts.config;

        if caller == &config.signer {
            config.evidence_signer = Some(hash);
        }
        else if caller == &config.counterparty {
            config.evidence_counterparty = Some(hash);
        } else {
            return Err(ErrorCode::Unauthorized.into());
        }

        Ok(())
    }

    pub fn decision(
        ctx: Context<Decision>,
        decision: bool
    ) -> Result<()> {
        let caller = ctx.accounts.signer.key();
        let config = &ctx.accounts.config;

        if caller == &config.arbitrator {
            if decision {

}

#[account]
pub struct EscrowConfig {
    pub counterparty: Pubkey,
    pub arbitrator: Pubkey,
    pub evidence_signer: Option<String>,
    pub evidence_counterparty: Option<String>,
}

#[derive(Accounts)]
pub struct Escrow<'info> {
    pub token_program: AccountInfo<'info>,
    pub escrow_tokens: Account<'info, TokenAccount>,
    pub signer: Signer<'info>,
    pub signer_tokens: Account<'info, TokenAccount>,
    pub config: Account<'info, EscrowConfig>
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    // Add constraints
    pub config: Account<'info, EscrowConfig>,
    pub token_program: AccountInfo<'info>,
    pub escrow_tokens: Account<'info, TokenAccount>,
    pub signer: Signer<'info>,
    pub signer_tokens: Account<'info, TokenAccount>,
}

#[derive(Accounts)]
pub struct Evidence<'info> {
}
