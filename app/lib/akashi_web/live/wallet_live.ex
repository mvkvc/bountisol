defmodule Akashi.WalletLive do
    use AkashiWeb, :live_view
  
    @impl true
    def render(assigns) do
      ~H"""
      <div>
        <%= live_react_component(
          "Components.WalletAdapter", 
          [network_type: Application.get_env(:akashi, Akashi.WalletLive)[:network]], 
          id: "wallet") 
        %>
      </div>
      """
    end
  
    @impl true
    def mount(_params, _session, socket) do
        {:ok, socket}
    end

    @impl true
    def handle_event(event, _params, socket) do
        IO.inspect(event, label: "WALLETLIVE EVENT")
        {:noreply, socket}
    end
end
