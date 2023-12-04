defmodule AkashiWeb.SignInLive do
  @moduledoc false
  use AkashiWeb, :live_view

  # alias Akashi.Accounts

  @impl true
  def render(assigns) do
    ~H"""
      <div class="flex flex-row space-x-4">
          <div id="wallet" phx-hook="Wallet">
          <%= if @connected do %>
            <button class="btn" phx-click="test-wallet-hook">
              Sign in
            </button>
          <% else %>
          <div class="relative">
            <button class="btn" disabled>
              Sign in
            </button>
            <span class="hidden absolute top-full mt-2 px-4 py-2 bg-black text-white text-sm rounded shadow-lg hover:block">
              Please install a Solana wallet
            </span>
          </div>
          <% end %>
          </div>
        <%= live_react_component(
          "Components.WalletAdapter",
          [network_type: Application.get_env(:akashi, Akashi.WalletLive)[:network]],
          id: "wallet-adapter"
        ) %>
      </div>
    """
  end
  
  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       connected: false,
       address: nil,
       signature: nil,
       verify_signature: false
     )}
  end

  @impl true
  def handle_event("test-wallet-hook", _params, socket) do
    IO.puts("test-wallet-hook")
    {:noreply, socket}
  end

  @impl true
  def handle_event("effect_connected", _params, socket) do
    push_event(socket, "test", %{hello: "there"})
    {:noreply, 
      socket
      |> assign(connected: true)
    }
  end

  @impl true
  def handle_event("effect_disconnecting", _params, socket) do
    {:noreply, 
    socket
    |> assign(connected: false)
    |> assign(address: nil)
    }
  end

  @impl true
  def handle_event("effect_public_key", %{"public_key" => public_key}, socket) do
    IO.inspect(public_key, label: "public_key")
    {:noreply, 
      socket
      |> assign(address: public_key)
    }
  end

  # @impl true
  # def handle_event("nonce", _params, socket) do
  #   address = socket.assigns.current_wallet_address
  #   {:ok, _user} = Accounts.create_user_if_not_exists(address)

  #   nonce =
  #     case Accounts.get_user_by_eth_address(address) do
  #       nil -> Accounts.generate_account_nonce()
  #       user -> user.eth_nonce
  #     end

  #   {:noreply, push_event(socket, "get-current-wallet", %{nonce: nonce})}
  # end

  # @impl true
  # def handle_event("verify_signature", params, socket) do
  #   {:noreply, assign(socket, signature: params["signature"], verify_signature: true)}
  # end
end
