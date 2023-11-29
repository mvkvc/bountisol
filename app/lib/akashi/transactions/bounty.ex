defmodule Akashi.Transactions.Bounty do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "bounties" do
    field :status, :string
    field :description, :string
    field :title, :string
    field :date_created, :naive_datetime
    field :date_closed, :naive_datetime
    field :funds_amount, :decimal
    field :funds_currency, :string
    field :attachments, {:array, :map}
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bounty, attrs) do
    bounty
    |> cast(attrs, [
      :title,
      :description,
      :date_created,
      :status,
      :date_closed,
      :funds_amount,
      :funds_currency,
      :attachments
    ])
    |> validate_required([
      :title,
      :description,
      :date_created,
      :status,
      :date_closed,
      :funds_amount,
      :funds_currency,
      :attachments
    ])
  end
end
