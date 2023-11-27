use anchor_lang::prelude::*;

declare_id!("72xay1vadtYKWM7BxSdXy7LQSCj3MRv8FsgFy4AmeSFz");

#[program]
pub mod akashi {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
