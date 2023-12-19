defmodule CTransfer.Repo.Migrations.CreateBounties do
  use Ecto.Migration

  def change do
    create table(:bounties) do
      add :title, :string
      add :description, :string
      add :date_created, :naive_datetime
      add :status, :string
      add :date_closed, :naive_datetime
      add :funds_amount, :decimal
      add :funds_currency, :string
      add :attachments, {:array, :map}
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:bounties, [:user_id])
  end
end
