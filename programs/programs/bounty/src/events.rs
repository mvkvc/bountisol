use anchor_lang::prelude::*;

#[event]
pub struct BountyCreated {
    pub address: Pubkey,
    pub bump: u8,
    pub deadline_work: u64,
    pub deadline_dispute: u64,
    pub admin: Pubkey,
    pub creator: Pubkey
}

#[event]
pub struct BountyAssigned {
    pub address: Pubkey,
    pub worker: Pubkey,
}

#[event]
pub struct BountyFunded {
    pub address: Pubkey,
    pub from: Pubkey,
    pub token: Pubkey,
    pub amount: u64,
}

#[event]
pub struct BountyReleased {
    pub address: Pubkey,
    pub to: Pubkey,
    pub token: Pubkey,
    pub amount: u64,
}
