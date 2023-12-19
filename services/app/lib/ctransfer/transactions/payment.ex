defmodule CTransfer.Transactions.Payment do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "payments" do
    field :status, :string, default: "requested"
    field :fiat_amount, :integer
    field :fiat_denom, :string
    field :crypto_amount, :integer
    field :crypto_denom, :string
    field :reciever_address, :string
    field :reciever_email, :string
    field :reciever_domain, :string
    field :user_id, :id
    field :tx_hash, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [
      :fiat_amount,
      :fiat_denom,
      :crypto_amount,
      :crypto_denom,
      :status,
      :reciever_address,
      :reciever_email,
      :reciever_domain,
      :tx_hash
    ])
    |> validate_required([
      :crypto_amount,
      :reciever_address
    ])
  end
end
