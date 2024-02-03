defmodule Bountisol.Oban.Arbitration do
  @moduledoc false
  use Oban.Worker, queue: :arbitration

  alias Bountisol.Accounts

  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{}}) do
  end
end
