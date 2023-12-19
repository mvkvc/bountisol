defmodule CTransfer.Repo do
  use Ecto.Repo,
    otp_app: :ctransfer,
    adapter: Ecto.Adapters.Postgres
end
