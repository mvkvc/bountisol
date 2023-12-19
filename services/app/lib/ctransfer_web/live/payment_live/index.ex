defmodule CTransferWeb.PaymentLive.Index do
  @moduledoc false
  use CTransferWeb, :live_view

  alias CTransfer.Transactions
  alias CTransfer.Transactions.Payment

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    current_user = socket.assigns.current_user
    {:ok, stream(socket, :payments, Transactions.list_payments_by_address(current_user.address))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Payment")
    |> assign(:payment, Transactions.get_payment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Payment")
    |> assign(:payment, %Payment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Payments")
    |> assign(:payment, nil)
  end

  @impl true
  def handle_info({CTransferWeb.PaymentLive.FormComponent, {:saved, payment}}, socket) do
    {:noreply, stream_insert(socket, :payments, payment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    payment = Transactions.get_payment!(id)
    {:ok, _} = Transactions.delete_payment(payment)

    {:noreply, stream_delete(socket, :payments, payment)}
  end

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end
end
