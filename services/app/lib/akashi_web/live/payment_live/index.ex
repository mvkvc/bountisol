defmodule AkashiWeb.PaymentLive.Index do
  use AkashiWeb, :live_view

  alias Akashi.Transactions
  alias Akashi.Transactions.Payment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :payments, Transactions.list_payments())}
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
  def handle_info({AkashiWeb.PaymentLive.FormComponent, {:saved, payment}}, socket) do
    {:noreply, stream_insert(socket, :payments, payment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    payment = Transactions.get_payment!(id)
    {:ok, _} = Transactions.delete_payment(payment)

    {:noreply, stream_delete(socket, :payments, payment)}
  end
end
