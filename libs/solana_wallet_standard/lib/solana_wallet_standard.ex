defmodule SolanaWalletStandard do
  alias SolanaWalletStandard.SignInInput
  alias SolanaWalletStandard.SignInOutput

  def verify_sign_in(%SignInInput{} = input, %SignInOutput{} = output) do
    %SignInOutput{
      # Public key should be a propery of wallet_account
      wallet_account: wallet_account,
      signed_message: signed_message,
      signature: signature
    } = output

    message = derive_sign_in_message(input, output)
    # message and verify_message_signature(message, signed_message, signature)
  end

  def verify_message_signature(message, signed_message, signature, public_key) do
    # Not sure about :none here
    message == signed_message and
      :crypto.verify(:eddsa, :none, message, signature, [public_key, :ed25519])
  end

  def derive_sign_in_message(input, output) do
    # text = create_sign_in_message_text(input)
    # :erlang.iolist_to_binary(text)
  end
end
