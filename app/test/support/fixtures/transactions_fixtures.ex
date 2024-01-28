defmodule CTransfer.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CTransfer.Transactions` context.
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
      |> CTransfer.Transactions.create_bounty()

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
      |> CTransfer.Transactions.create_payment()

    payment
  end

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(attrs \\ %{}) do
    {:ok, invoice} =
      attrs
      |> Enum.into(%{
        cancelled: true,
        crypto_amount: 42,
        crypto_denom: "some crypto_denom",
        end_date: ~N[2023-12-06 17:45:00],
        fiat_amount: 42,
        fiat_denom: "some fiat_denom",
        paused: true,
        recurring: true,
        start_date: ~N[2023-12-06 17:45:00]
      })
      |> CTransfer.Transactions.create_invoice()

    invoice
  end
end
