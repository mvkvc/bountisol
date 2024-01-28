defmodule CTransfer.Repo.Migrations.AddPaymentType do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :type, :string, null: false
    end
  end
end
