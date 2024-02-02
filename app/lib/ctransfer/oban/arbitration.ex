defmodule CTransfer.Oban.Arbitration do
  @moduledoc false
  use Oban.Worker, queue: :arbitration

  alias CTransfer.Accounts

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{}}) do
  end
end
