defmodule AkashiWeb.PaymentLive.Show do
  @moduledoc false
  use AkashiWeb, :live_view

  alias Akashi.Transactions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:payment, Transactions.get_payment!(id))}
  end

  defp page_title(:show), do: "Show Payment"
  defp page_title(:edit), do: "Edit Payment"
end
