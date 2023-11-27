defmodule SolanaWalletStandard.SignInOutput do
  @enforce_keys [:wallet_account, :signed_message, :signature]
  defstruct [:wallet_account, :signed_message, :signature, signature_type: :ed25519]
end
