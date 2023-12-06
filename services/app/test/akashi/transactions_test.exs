defmodule Akashi.TransactionsTest do
  use Akashi.DataCase

  alias Akashi.Transactions

  describe "bounties" do
    import Akashi.TransactionsFixtures

    alias Akashi.Transactions.Bounty

    @invalid_attrs %{
      status: nil,
      description: nil,
      title: nil,
      date_created: nil,
      date_closed: nil,
      funds_amount: nil,
      funds_currency: nil,
      attachments: nil
    }

    test "list_bounties/0 returns all bounties" do
      bounty = bounty_fixture()
      assert Transactions.list_bounties() == [bounty]
    end

    test "get_bounty!/1 returns the bounty with given id" do
      bounty = bounty_fixture()
      assert Transactions.get_bounty!(bounty.id) == bounty
    end

    test "create_bounty/1 with valid data creates a bounty" do
      valid_attrs = %{
        status: "some status",
        description: "some description",
        title: "some title",
        date_created: ~N[2023-11-28 20:15:00],
        date_closed: ~N[2023-11-28 20:15:00],
        funds_amount: "120.5",
        funds_currency: "some funds_currency",
        attachments: []
      }

      assert {:ok, %Bounty{} = bounty} = Transactions.create_bounty(valid_attrs)
      assert bounty.status == "some status"
      assert bounty.description == "some description"
      assert bounty.title == "some title"
      assert bounty.date_created == ~N[2023-11-28 20:15:00]
      assert bounty.date_closed == ~N[2023-11-28 20:15:00]
      assert bounty.funds_amount == Decimal.new("120.5")
      assert bounty.funds_currency == "some funds_currency"
      assert bounty.attachments == []
    end

    test "create_bounty/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_bounty(@invalid_attrs)
    end

    test "update_bounty/2 with valid data updates the bounty" do
      bounty = bounty_fixture()

      update_attrs = %{
        status: "some updated status",
        description: "some updated description",
        title: "some updated title",
        date_created: ~N[2023-11-29 20:15:00],
        date_closed: ~N[2023-11-29 20:15:00],
        funds_amount: "456.7",
        funds_currency: "some updated funds_currency",
        attachments: []
      }

      assert {:ok, %Bounty{} = bounty} = Transactions.update_bounty(bounty, update_attrs)
      assert bounty.status == "some updated status"
      assert bounty.description == "some updated description"
      assert bounty.title == "some updated title"
      assert bounty.date_created == ~N[2023-11-29 20:15:00]
      assert bounty.date_closed == ~N[2023-11-29 20:15:00]
      assert bounty.funds_amount == Decimal.new("456.7")
      assert bounty.funds_currency == "some updated funds_currency"
      assert bounty.attachments == []
    end

    test "update_bounty/2 with invalid data returns error changeset" do
      bounty = bounty_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_bounty(bounty, @invalid_attrs)
      assert bounty == Transactions.get_bounty!(bounty.id)
    end

    test "delete_bounty/1 deletes the bounty" do
      bounty = bounty_fixture()
      assert {:ok, %Bounty{}} = Transactions.delete_bounty(bounty)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_bounty!(bounty.id) end
    end

    test "change_bounty/1 returns a bounty changeset" do
      bounty = bounty_fixture()
      assert %Ecto.Changeset{} = Transactions.change_bounty(bounty)
    end
  end

  describe "payments" do
    alias Akashi.Transactions.Payment

    import Akashi.TransactionsFixtures

    @invalid_attrs %{status: nil, fiat_amount: nil, fiat_denom: nil, crypto_amount: nil, crypto_denom: nil, reciever_address: nil, reciever_email: nil, reciever_domain: nil}

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Transactions.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Transactions.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      valid_attrs = %{status: "some status", fiat_amount: 42, fiat_denom: "some fiat_denom", crypto_amount: 42, crypto_denom: "some crypto_denom", reciever_address: "some reciever_address", reciever_email: "some reciever_email", reciever_domain: "some reciever_domain"}

      assert {:ok, %Payment{} = payment} = Transactions.create_payment(valid_attrs)
      assert payment.status == "some status"
      assert payment.fiat_amount == 42
      assert payment.fiat_denom == "some fiat_denom"
      assert payment.crypto_amount == 42
      assert payment.crypto_denom == "some crypto_denom"
      assert payment.reciever_address == "some reciever_address"
      assert payment.reciever_email == "some reciever_email"
      assert payment.reciever_domain == "some reciever_domain"
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      update_attrs = %{status: "some updated status", fiat_amount: 43, fiat_denom: "some updated fiat_denom", crypto_amount: 43, crypto_denom: "some updated crypto_denom", reciever_address: "some updated reciever_address", reciever_email: "some updated reciever_email", reciever_domain: "some updated reciever_domain"}

      assert {:ok, %Payment{} = payment} = Transactions.update_payment(payment, update_attrs)
      assert payment.status == "some updated status"
      assert payment.fiat_amount == 43
      assert payment.fiat_denom == "some updated fiat_denom"
      assert payment.crypto_amount == 43
      assert payment.crypto_denom == "some updated crypto_denom"
      assert payment.reciever_address == "some updated reciever_address"
      assert payment.reciever_email == "some updated reciever_email"
      assert payment.reciever_domain == "some updated reciever_domain"
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_payment(payment, @invalid_attrs)
      assert payment == Transactions.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Transactions.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Transactions.change_payment(payment)
    end
  end
end
