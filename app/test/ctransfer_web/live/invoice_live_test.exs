defmodule CTransferWeb.InvoiceLiveTest do
  use CTransferWeb.ConnCase

  import CTransfer.TransactionsFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{
    cancelled: true,
    fiat_denom: "some fiat_denom",
    fiat_amount: 42,
    crypto_denom: "some crypto_denom",
    crypto_amount: 42,
    recurring: true,
    start_date: "2023-12-06T17:45:00",
    end_date: "2023-12-06T17:45:00",
    paused: true
  }
  @update_attrs %{
    cancelled: false,
    fiat_denom: "some updated fiat_denom",
    fiat_amount: 43,
    crypto_denom: "some updated crypto_denom",
    crypto_amount: 43,
    recurring: false,
    start_date: "2023-12-07T17:45:00",
    end_date: "2023-12-07T17:45:00",
    paused: false
  }
  @invalid_attrs %{
    cancelled: false,
    fiat_denom: nil,
    fiat_amount: nil,
    crypto_denom: nil,
    crypto_amount: nil,
    recurring: false,
    start_date: nil,
    end_date: nil,
    paused: false
  }

  defp create_invoice(_) do
    invoice = invoice_fixture()
    %{invoice: invoice}
  end

  describe "Index" do
    setup [:create_invoice]

    test "lists all invoices", %{conn: conn, invoice: invoice} do
      {:ok, _index_live, html} = live(conn, ~p"/invoices")

      assert html =~ "Listing Invoices"
      assert html =~ invoice.fiat_denom
    end

    test "saves new invoice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("a", "New Invoice") |> render_click() =~
               "New Invoice"

      assert_patch(index_live, ~p"/invoices/new")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice created successfully"
      assert html =~ "some fiat_denom"
    end

    test "updates invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(index_live, ~p"/invoices/#{invoice}/edit")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated fiat_denom"
    end

    test "deletes invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#invoices-#{invoice.id}")
    end
  end

  describe "Show" do
    setup [:create_invoice]

    test "displays invoice", %{conn: conn, invoice: invoice} do
      {:ok, _show_live, html} = live(conn, ~p"/invoices/#{invoice}")

      assert html =~ "Show Invoice"
      assert html =~ invoice.fiat_denom
    end

    test "updates invoice within modal", %{conn: conn, invoice: invoice} do
      {:ok, show_live, _html} = live(conn, ~p"/invoices/#{invoice}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(show_live, ~p"/invoices/#{invoice}/show/edit")

      assert show_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/invoices/#{invoice}")

      html = render(show_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated fiat_denom"
    end
  end
end
