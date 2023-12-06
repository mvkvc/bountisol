defmodule Akashi.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :fiat_amount, :integer
      add :fiat_denom, :string
      add :crypto_amount, :integer
      add :crypto_denom, :string
      add :status, :string
      add :reciever_address, :string
      add :reciever_email, :string
      add :reciever_domain, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:payments, [:user_id])
  end
end
