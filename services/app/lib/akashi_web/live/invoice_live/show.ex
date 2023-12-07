defmodule AkashiWeb.InvoiceLive.Show do
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
     |> assign(:invoice, Transactions.get_invoice!(id))}
  end

  defp page_title(:show), do: "Show Invoice"
  defp page_title(:edit), do: "Edit Invoice"
end
