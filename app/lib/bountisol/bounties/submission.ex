defmodule Bountisol.Bounties.Submission do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bountisol.Accounts.User
  alias Bountisol.Bounties.Bounty

  schema "submissions" do
    field :content, :string

    belongs_to :user, User
    belongs_to :bounty, Bounty

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
