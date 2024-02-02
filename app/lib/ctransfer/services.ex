defmodule CTransfer.Services do
  @moduledoc false
  alias CTransfer.Accounts

  def verify_signature(%{address: address, message: message, signature: signature} = params) do
    IO.inspect(params, label: "params")
    message = Jason.decode!(message)
    signature = Jason.decode!(signature)

    IO.inspect(signature, label: "signature")

    result = Portboy.run_pool(:js, "siws", %{message: message, signature: signature["signature"]["data"]})

    if result do
      Accounts.get_user_by_address(address)
    end
  end
end
