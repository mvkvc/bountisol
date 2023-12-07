defmodule AkashiWeb.WalletLive do
  @moduledoc false
  use AkashiWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= live_react_component(
        "Components.WalletAdapter",
        [network_type: Application.get_env(:akashi, :network)],
        id: "wallet"
      ) %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event(event, _params, socket) do
    IO.inspect(event, label: "WALLET LIVE")
    {:noreply, socket}
  end
end
