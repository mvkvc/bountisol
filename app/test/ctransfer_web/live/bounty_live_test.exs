defmodule CTransferWeb.BountyLiveTest do
  use CTransferWeb.ConnCase

  import CTransfer.TransactionsFixtures
  import Phoenix.LiveViewTest

  @create_attrs %{
    status: "some status",
    description: "some description",
    title: "some title",
    date_created: "2023-11-28T20:15:00",
    date_closed: "2023-11-28T20:15:00",
    funds_amount: "120.5",
    funds_currency: "some funds_currency",
    attachments: []
  }
  @update_attrs %{
    status: "some updated status",
    description: "some updated description",
    title: "some updated title",
    date_created: "2023-11-29T20:15:00",
    date_closed: "2023-11-29T20:15:00",
    funds_amount: "456.7",
    funds_currency: "some updated funds_currency",
    attachments: []
  }
  @invalid_attrs %{
    status: nil,
    description: nil,
    title: nil,
    date_created: nil,
    date_closed: nil,
    funds_amount: nil,
    funds_currency: nil,
    attachments: []
  }

  defp create_bounty(_) do
    bounty = bounty_fixture()
    %{bounty: bounty}
  end

  describe "Index" do
    setup [:create_bounty]

    test "lists all bounties", %{conn: conn, bounty: bounty} do
      {:ok, _index_live, html} = live(conn, ~p"/bounties")

      assert html =~ "Listing Bounties"
      assert html =~ bounty.status
    end

    test "saves new bounty", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("a", "New Bounty") |> render_click() =~
               "New Bounty"

      assert_patch(index_live, ~p"/bounties/new")

      assert index_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bounty-form", bounty: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bounties")

      html = render(index_live)
      assert html =~ "Bounty created successfully"
      assert html =~ "some status"
    end

    test "updates bounty in listing", %{conn: conn, bounty: bounty} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("#bounties-#{bounty.id} a", "Edit") |> render_click() =~
               "Edit Bounty"

      assert_patch(index_live, ~p"/bounties/#{bounty}/edit")

      assert index_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bounty-form", bounty: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/bounties")

      html = render(index_live)
      assert html =~ "Bounty updated successfully"
      assert html =~ "some updated status"
    end

    test "deletes bounty in listing", %{conn: conn, bounty: bounty} do
      {:ok, index_live, _html} = live(conn, ~p"/bounties")

      assert index_live |> element("#bounties-#{bounty.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bounties-#{bounty.id}")
    end
  end

  describe "Show" do
    setup [:create_bounty]

    test "displays bounty", %{conn: conn, bounty: bounty} do
      {:ok, _show_live, html} = live(conn, ~p"/bounties/#{bounty}")

      assert html =~ "Show Bounty"
      assert html =~ bounty.status
    end

    test "updates bounty within modal", %{conn: conn, bounty: bounty} do
      {:ok, show_live, _html} = live(conn, ~p"/bounties/#{bounty}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bounty"

      assert_patch(show_live, ~p"/bounties/#{bounty}/show/edit")

      assert show_live
             |> form("#bounty-form", bounty: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#bounty-form", bounty: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/bounties/#{bounty}")

      html = render(show_live)
      assert html =~ "Bounty updated successfully"
      assert html =~ "some updated status"
    end
  end
end
