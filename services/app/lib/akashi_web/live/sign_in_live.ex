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
    <div id="wallet" class="flex flex-row" phx-hook="Wallet">
      <%= if @connected do %>
        <%= if is_nil(@current_user) do %>
          <div class="mr-4">
            <.form
              for={%{}}
              action={~p"/users/log_in"}
              as={:user}
              phx-submit="verify"
              phx-trigger-action={@trigger}
            >
              <.input type="hidden" name="address" value={@address} />
              <.input type="hidden" name="message" value={@message} />
              <.input type="hidden" name="signature" value={@signature} />
              <button class="btn">
                Sign in
              </button>
            </.form>
          </div>
        <% end %>
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
      <%= live_react_component(
        "Components.WalletAdapter",
        [network_type: Application.get_env(:akashi, Akashi.WalletLive)[:network]],
        id: "wallet-adapter"
      ) %>
    </div>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)

    {:ok,
     assign(socket,
       trigger: false,
       connected: false,
       verified: false,
       address: nil,
       message: nil,
       signature: nil
     )}
  end

  @impl true
  def handle_event("verify", _params, socket) do
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
  def handle_event("sign_out", _params, socket) do
    {:noreply,
     socket
     |> UserAuth.log_out_user()
     |> assign(verified: false)}
  end

  @impl true
  def handle_event("verify-signature", %{
    "signature" => signature, 
    "message" => message
    } = _payload, socket) do
    {:noreply,
     socket
     |> assign(signature: signature)
     |> assign(message: message)
     |> assign(trigger: true)}
  end

  @impl true
  def handle_event("effect_connected", _params, socket) do
    {:noreply,
     socket
     |> assign(connected: true)
     |> push_event("test", %{hello: "there"})}
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

  defp assign_current_user(socket, session) do
    case session do
      %{"user_token" => user_token} ->
        assign_new(socket, :current_user, fn ->
          Accounts.get_user_by_session_token(user_token)
        end)

      %{} ->
        assign_new(socket, :current_user, fn -> nil end)
    end
  end
end
