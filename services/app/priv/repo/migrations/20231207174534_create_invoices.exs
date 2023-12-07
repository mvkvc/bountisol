defmodule Akashi.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :fiat_denom, :string
      add :fiat_amount, :integer
      add :crypto_denom, :string
      add :crypto_amount, :integer
      add :recurring, :boolean, default: false, null: false
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime
      add :paused, :boolean, default: false, null: false
      add :cancelled, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
