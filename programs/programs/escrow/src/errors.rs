use anchor_lang::prelude::*;

#[error_code]
pub enum EscrowError {
    #[msg("This token is unsupported.")]
    UnsupportedTokenError,

    #[msg("This is not the correct token for this escrow.")]
    InvalidTokenError,

    #[msg("The escrow requires more funds.")]
    InsufficientFundsError,
}
