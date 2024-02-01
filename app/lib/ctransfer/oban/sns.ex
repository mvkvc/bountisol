defmodule CTransfer.Oban.SNS do
  use Oban.Worker, queue: :default
  require Logger
  alias CTransfer.Accounts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"address" => address}}) do
    case Portboy.run_pool(:js, "sns", %{address: address}) do
      {:ok, result} ->
        result = String.trim(result)
        Accounts.update_user_domain(address, result <> ".sol")

      {:error, reason} -> Logger.error("SNS lookup failed: #{inspect(reason)}")
    end
  end
end
