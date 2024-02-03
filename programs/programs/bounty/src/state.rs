use anchor_lang::{prelude::*, system_program};
use anchor_spl::token::{transfer, Mint, Token, TokenAccount, Transfer};

#[account]
pub struct Bounty {
    pub bump: u8,
    pub assets: Vec<Pubkey>,
    pub amount: u64,
    pub deadline: u64,
    pub dispute_period: u64,
    pub disputed: bool,
    pub admin: Pubkey,
    pub creator: Pubkey,
    pub workers: Vec<Pubkey>
}

impl Bounty {
    pub const SEED_PREFIX: &'static str = "bountisol_bounty";
    pub const SPACE: usize = 8 + 1 + 4 + 8 + 8 + 32 + 32 + 4; // https://book.anchor-lang.com/anchor_references/space.html

    pub fn new(
        bump: u8,
        amount: u64,
        deadline: u64,
        admin: Pubkey,
        creator: Pubkey
    ) -> Self {
        Self {
            bump,
            assets: vec![],
            amount,
            deadline,
            admin,
            creator,
            workers: vec![]
        }
    }
}

pub trait BountyAccount<'info> {

}

impl<'info> BountyAccount<'info> for Account<'info, Bounty> {

}
