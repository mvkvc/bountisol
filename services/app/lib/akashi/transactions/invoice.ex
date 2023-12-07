defmodule Akashi.Transactions.Invoice do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "invoices" do
    field :cancelled, :boolean, default: false
    field :fiat_denom, :string
    field :fiat_amount, :integer
    field :crypto_denom, :string
    field :crypto_amount, :integer
    field :recurring, :boolean, default: false
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime
    field :paused, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :fiat_denom,
      :fiat_amount,
      :crypto_denom,
      :crypto_amount,
      :recurring,
      :start_date,
      :end_date,
      :paused,
      :cancelled
    ])
    |> validate_required([
      :fiat_denom,
      :fiat_amount,
      :crypto_denom,
      :crypto_amount,
      :recurring,
      :start_date,
      :end_date,
      :paused,
      :cancelled
    ])
  end
end
