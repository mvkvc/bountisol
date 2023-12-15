defmodule AkashiWeb.PaymentLive.Send do
  @moduledoc false
  use AkashiWeb, :live_view

  alias Akashi.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Payment <%= @payment.id %>
      <:subtitle>Click to send this payment!</:subtitle>
      <:actions>
        <%= if @payment.status == "requested" do %>
          <.link phx-click="send-payment" phx-hook="Wallet" id="send-payment">
            <button class="btn">Send payment</button>
          </.link>
        <% end %>
      </:actions>
    </.header>

    <.list>
      <:item title="Status"><%= @payment.status %></:item>

      <:item title="Crypto amount"><%= @payment.crypto_amount %></:item>
      <:item title="Reciever address"><%= @payment.reciever_address %></:item>

      <:item title="Transaction">
        <.link href={"https://solana.fm/tx/#{@payment.tx_hash}" <> if Application.get_env(:akashi, :network) && Application.get_env(:akashi, :network) == :devnet, do: "?cluster=devnet-solana", else: ""}>
          <%= @payment.tx_hash %>
        </.link>
      </:item>
    </.list>

    <.back navigate={~p"/payments"}>Back to payments</.back>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, assign(socket, :payment, Transactions.get_payment!(id))}
  end

  @impl true
  def handle_event("send-payment", _params, socket) do
    payload = %{
      network_url: System.fetch_env!("APP_RPC_URL"),
      to_address: socket.assigns.payment.reciever_address,
      amount_sol: socket.assigns.payment.crypto_amount,
      fee_pct: System.fetch_env!("APP_FEE_PCT"),
      fee_address: System.fetch_env!("APP_FEE_ADDRESS")
    }

    {:noreply, push_event(socket, "send-payment", payload)}
  end

  @impl true
  def handle_event("payment-sent", %{"tx" => %{"publicKey" => _publicKey, "signature" => signature}}, socket) do
    payment = socket.assigns.payment

    attrs = %{
      tx_hash: signature,
      status: "sent"
    }

    case Transactions.update_payment(payment, attrs) do
      {:ok, payment} ->
        {:noreply,
         socket
         |> assign(:payment, payment)
         |> put_flash(:info, "Payment sent!")}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end
end
