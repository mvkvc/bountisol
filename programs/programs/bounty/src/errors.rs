use anchor_lang::prelude::*;

#[error_code]
pub enum BountyError {
    // #[msg("This token is unsupported.")]
    // UnsupportedToken,

    // #[msg("This is not the correct token for this escrow.")]
    // InvalidToken,

    // #[msg("The escrow requires more funds.")]
    // InsufficientFunds,

    // #[msg("The amount of funds to release is invalid.")]
    // InvalidReleaseAmount,

    // #[msg("The amount of funds to release is invalid.")]
    // InvalidAmount,

    // #[msg("The asset key is invalid.")]
    // InvalidAssetKey,

    // #[msg("The payer is not authorized to call this instruction.")]
    // InvalidPayer,

    // #[msg("The worker is not authorized to call this instruction.")]
    // InvalidWorker,

    // #[msg("The deadline has not passed.")]
    // InvalidTime,

    // #[msg("The escrow has already been assigned.")]
    // AlreadyAssigned,

    // #[msg("The escrow has already been disputed.")]
    // AlreadyDisputed,

    // #[msg("The escrow has no worker.")]
    // NoWorker,

    // #[msg("The deadline has not passed.")]
    // BeforeDeadline

    // #[msg("The escrow has not been disputed.")]
    // NotDisputed,

    // #[msg("This account has already been added.")]
    // DuplicateRecipient,
}
