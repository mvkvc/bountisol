defmodule Akashi.Repo.Migrations.AddTxHash do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :tx_hash, :string
      modify :status, :string, default: "requested"
    end
  end
end
