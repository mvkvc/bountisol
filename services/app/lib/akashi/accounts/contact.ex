defmodule Akashi.Accounts.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akashi.Accounts.User

  schema "contacts" do
    field :domain, :string
    field :description, :string
    field :email, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:domain, :email, :description])
    |> validate_required([:domain, :email, :description])
  end
end
