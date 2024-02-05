defmodule Bountisol.Bounties.Bounty do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bountisol.Accounts.User
  alias Bountisol.Bounties.Submission

  schema "bounties" do
    field :title, :string
    field :requirements, :string
    field :summary, :string
    field :tokens, :map

    belongs_to :user, User
    has_many :submissions, Submission

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(bounty, attrs) do
    bounty
    |> cast(attrs, [:title, :summary, :requirements, :tokens])
    |> validate_required([:title, :summary, :requirements])
  end
end
