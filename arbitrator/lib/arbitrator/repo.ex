defmodule Arbitrator.Repo do
  use Ecto.Repo,
    otp_app: :arbitrator,
    adapter: Ecto.Adapters.SQLite3
end
