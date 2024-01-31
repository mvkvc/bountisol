defmodule CTransfer.Jobs.SNS do
  use Oban.Worker, queue: :default
  alias ElixirSense.Log
  alias CTransfer.Accounts
  alias CTransfer.Accounts.User
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"address" => address} = args}) do
    case Portboy.run_pool(:js, "sns", %{address: address}) do
      {:ok, result} ->
        Accounts.update_user_domain(address, result <> ".sol")
      {:error, reason} -> Logger.error("SNS lookup failed: #{inspect(reason)}")
    end
  end
end
