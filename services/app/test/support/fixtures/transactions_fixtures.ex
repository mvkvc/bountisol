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

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        crypto_amount: 42,
        crypto_denom: "some crypto_denom",
        fiat_amount: 42,
        fiat_denom: "some fiat_denom",
        reciever_address: "some reciever_address",
        reciever_domain: "some reciever_domain",
        reciever_email: "some reciever_email",
        status: "some status"
      })
      |> Akashi.Transactions.create_payment()

    payment
  end
end
