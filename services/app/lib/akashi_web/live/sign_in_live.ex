defmodule AkashiWeb.SignInLive do
  @moduledoc false
  use AkashiWeb, :live_view

  # alias Akashi.Accounts

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect("mount")
    # Process.send_after(self(), :wallet_status, 100, [])

    {:ok,
     assign(socket,
       has_wallet: false,
       connected: false,
       current_wallet_address: nil,
       signature: nil,
       verify_signature: false
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <span>
      <%= if @connected do %>
        <button class="btn">
          Sign in
        </button>
      <% else %>
        <button class="btn" disabled>
          No Wallet
        </button>
      <% end %>
    </span>
    """
  end

  @impl true
  def handle_event(event, _params, socket) do
    IO.inspect(event, label: "SIGN IN LIVE")
    {:noreply, socket}
  end

  @impl true
  def handle_info(:wallet_status, socket) do
    if connected?(socket) and !is_nil(socket.assigns.has_wallet) do
      Process.send(self(), :has_wallet, [])
    end

    {:noreply, socket}
  end

  @impl true
  def handle_info(info, socket) do
    IO.inspect(info, "SIGN IN INFO")

    {:noreply, socket}
  end

  # @impl true
  # def handle_event("has-wallet", params, socket) do
  #   # IO.inspect("has-wallet")
  #   has_wallet = params["has_wallet"]

  #   {:noreply, assign(socket, has_wallet: has_wallet)}
  # end

  # @impl true
  # def handle_event("account-check", params, socket) do
  #   # IO.inspect("account-check")

  #   {:noreply,
  #    assign(socket,
  #      connected: params["connected"],
  #      current_wallet_address: params["current_wallet_address"]
  #    )}
  # end

  # @impl true
  # def handle_event("connect-wallet", params, socket) do
  #   # IO.inspect("connect-wallet")

  #   {:noreply, push_event(socket, "connect-wallet", %{})}
  # end

  # @impl true
  # def handle_event("wallet-connected", params, socket) do
  #   # IO.inspect("wallet-connected")

  #   {:noreply,
  #    assign(socket,
  #      connected: not is_nil(params["public_address"]),
  #      current_wallet_address: params["public_address"]
  #    )}
  # end

  # @impl true
  # def handle_event("verify-current-wallet", _params, socket) do
  #   # IO.inspect("verify-current-wallet")

  #   address = socket.assigns.current_wallet_address
  #   {:ok, _user} = Accounts.create_user_if_not_exists(address)

  #   # Not sure if this logic still
  #   nonce =
  #     case Accounts.get_user_by_eth_address(address) do
  #       nil -> Accounts.generate_account_nonce()
  #       user -> user.eth_nonce
  #     end

  #   {:noreply, push_event(socket, "get-current-wallet", %{nonce: nonce})}
  # end

  # @impl true
  # def handle_event("verify-signature", params, socket) do
  #   # IO.inspect("verify-signature")

  #   {:noreply, assign(socket, signature: params["signature"], verify_signature: true)}
  # end
end
