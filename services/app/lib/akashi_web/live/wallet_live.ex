defmodule Akashi.WalletLive do
  @moduledoc false
  use AkashiWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= live_react_component(
        "Components.WalletAdapter",
        [network_type: Application.get_env(:akashi, Akashi.WalletLive)[:network]],
        id: "wallet"
      ) %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
