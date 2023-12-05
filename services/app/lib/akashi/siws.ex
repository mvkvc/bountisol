defmodule Akashi.SIWS do
  @moduledoc false
  alias Akashi.Accounts

  def verify_signature(%{address: address, message: message, signature: signature}) do
    request =
      Req.post!(
        "http://localhost:3000/siws",
        json: %{
          message: message,
          address: address,
          signature: signature
        }
      )

    case request.status do
      200 ->
        if Map.get(request.body, "verified") && Map.get(request.body, "verified") == true do
          IO.puts("Verified")
          {:ok, user} = Accounts.create_user_if_not_exists(address)
          user
        else
          IO.puts("Not verified")
          nil
        end

      _ ->
        IO.puts("Error")
        nil
    end
  end
end
