defmodule AkashiWeb.SignInLive do
  @moduledoc false
  use AkashiWeb, :live_view

  alias Akashi.Accounts

  @statement """
  You are signing this message with your Solana wallet to sign in to Akashi.
  """

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-row space-x-4">
      <div id="wallet" phx-hook="Wallet">
      <%= if @verified do %>
        <button class="btn">
          @address
        </button>
      <% else %>
        <%= if @connected do %>
          <button class="btn" phx-click="sign_in">
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
       verified: false,
       address: nil
     )}
  end

  @impl true
  def handle_event("sign_in", _params, socket) do
    address = socket.assigns.address
    {:ok, _user} = Accounts.create_user_if_not_exists(address)

    nonce =
      case Accounts.get_user_by_address(address) do
        nil -> Accounts.generate_account_nonce()
        user -> user.nonce
      end

    {:noreply,
     push_event(socket, "signature", %{
       address: address,
       statement: @statement,
       nonce: nonce
     })}
  end

  @impl true
  def handle_event("verify-signature", payload, socket) do
    message = Map.get(payload, "message")
    address = Map.get(payload, "signedMessage") |> Map.get("publicKey")
    signature = Map.get(payload, "signedMessage") |> Map.get("signature")

    request = Req.post!(
      "http://localhost:3000/siws", 
      json: %{
        message: message,
        address: address,
        signature: signature
      })

    if request.status == 200 do
      socket = assign(socket, verified: Map.get(request.body, "verified"))
    end
    {:noreply, socket}
  end

  @impl true
  def handle_event("effect_connected", _params, socket) do
    {:noreply, 
      socket
      |> assign(connected: true)
      |> push_event("test", %{hello: "there"})
    }
  end

  @impl true
  def handle_event("effect_disconnecting", _params, socket) do
    {:noreply,
     socket
     |> assign(connected: false)
     |> assign(address: nil)}
  end

  @impl true
  def handle_event("effect_public_key", %{"public_key" => public_key}, socket) do
    {:noreply, assign(socket, address: public_key)}
  end
end
