defmodule Akashi.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Akashi.Transactions` context.
  """

  @doc """
  Generate a bounty.
  """
  def bounty_fixture(attrs \\ %{}) do
    {:ok, bounty} =
      attrs
      |> Enum.into(%{
        attachments: [],
        date_closed: ~N[2023-11-28 20:15:00],
        date_created: ~N[2023-11-28 20:15:00],
        description: "some description",
        funds_amount: "120.5",
        funds_currency: "some funds_currency",
        status: "some status",
        title: "some title"
      })
      |> Akashi.Transactions.create_bounty()

    bounty
  end
end
