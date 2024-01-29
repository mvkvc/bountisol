defmodule CTransfer.Solana do
  @moduledoc false
  alias CTransfer.Accounts

  def verify_signature(%{address: address, message: message, signature: signature}) do
    # Portboy.run_pool(:solana)
    req =
      Req.post(
        System.fetch_env!("APP_VERIFY_URL"),
        json: %{
          message: message,
          address: address,
          signature: signature
        }
      )

    case req do
      {:ok, %Req.Response{status: 200, body: body}} ->
        if Map.get(body, "verified") == true do
          IO.puts("Verified")
          Accounts.get_user_by_address(address)
        else
          IO.puts("Not verified")
          nil
        end

      _ ->
        IO.puts("Error with request for verification")
        nil
    end
  end
end
