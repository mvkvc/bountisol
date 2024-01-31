use anchor_lang::prelude::*;

#[error_code]
pub enum EscrowProgramError {
    #[msg("This token is unsupported.")]
    UnsupportedTokenError,

    #[msg("This is not the correct token for this escrow.")]
    InvalidTokenError,

    #[msg("The escrow requires more funds.")]
    InsufficientFundsError,

    #[msg("The amount of funds to release is invalid.")]
    InvalidReleaseAmountError,

    #[msg("The amount of funds to release is invalid.")]
    InvalidAmountError,

    #[msg("The asset key is invalid.")]
    InvalidAssetKey,

    #[msg("The payer is not authorized to call this instruction.")]
    InvalidPayerError,

    #[msg("The worker is not authorized to call this instruction.")]
    InvalidWorkerError,

    #[msg("The deadline has not passed.")]
    InvalidTimeError,
}
