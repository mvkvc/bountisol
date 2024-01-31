defmodule CTransfer.Repo.Migrations.AddSnsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # Array of strings
      add :sns, {:array, :string}
    end
  end
end
