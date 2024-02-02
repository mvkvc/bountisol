defmodule CTransfer.Grammar.Arbitration do
  @moduledoc false
  use Ecto.Schema
  use Instructor.Validator

  @primary_key false
  embedded_schema do
    field(:awarded, Ecto.Enum, values: [:creator, :worker, :split])
    field(:explanation, :string)
  end

  @impl true
  def validate_changeset(changeset) do
    Ecto.Changeset.validate_length(changeset, :explanation, min: 100)
  end
end
