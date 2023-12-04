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
  def handle_event("sign_in", _params, socket) do
    address = socket.assigns.address
    {:ok, _user} = Accounts.create_user_if_not_exists(address)

    nonce =
      case Accounts.get_user_by_address(address) do
        nil -> Accounts.generate_account_nonce()
        user -> user.nonce
      end

      # Create this data on backend and send
      # const signInData: SolanaSignInInput = {
      #   domain,
      #   statement:
      #     "Clicking Sign or Approve only means you have proved this wallet is owned by you. This request will not trigger any blockchain transaction or cost any gas fee.",
      #   version: "1",
      #   nonce: "oBbLoEldZs",
      #   chainId: "mainnet",
      #   issuedAt: currentDateTime,
      #   resources: ["https://example.com", "https://phantom.app/"],
      # };

    {:noreply,
     push_event(socket, "signature", %{
       address: address,
       statement: @statement,
       nonce: nonce
     })}
  end

  @impl true
  def handle_event("verify-signature", payload, socket) do
    IO.inspect(payload, label: "verify-signature")
    message = Map.get(payload, "message")
    address = Map.get(payload, "signedMessage") |> Map.get("publicKey")
    signature = Map.get(payload, "signedMessage") |> Map.get("signature")

    request = Req.post!("http://localhost:3000/siws", json: %{
        message: message,
        address: address,
        signature: signature
      })

    IO.inspect(request, label: "verify-signature")
    IO.inspect({message, address, signature}, label: "verify-signature")
    {:noreply, socket}
  end

  # def handle_event("verify-signature", %{"signature" => signature, "statement" => statement, "address" => address} = payload, socket) do
  #   signature = Map.get(signature, "data") |> :binary.list_to_bin()
  #   IO.inspect({signature, statement, address}, label: "verify-signature")

  #   verify = :enacl.sign_verify_detached(statement, signature, address)
  #   IO.inspect(verify, label: "verify")
  #   {:noreply, socket}
  # end

  # def handle_event("verify-signature", %{"signature" => signature, "statement" => statement, "address" => address} = payload, socket) do
  #   # IO.inspect({signature, statement, address}, label: "verify-signature")
  
  #   # Assuming `signature` is Base58 encoded and `data` is the field containing the encoded signature
  #   signature_binary = Base58.decode(Map.get(signature, "data") |> :binary.list_to_bin())
  
  #   # `statement` is assumed to be a UTF-8 encoded string, which is already binary in Elixir
  #   statement_binary = statement
  
  #   # Assuming `address` is a Base58 encoded public key
  #   public_key_binary = Base58.decode(address)

  #   IO.inspect({signature_binary, statement_binary, public_key_binary}, label: "verify-signature")
  
  #   case :enacl.sign_verify_detached(signature_binary, statement_binary, public_key_binary) do
  #     true -> IO.puts("Signature verified")
  #     false -> IO.puts("Signature not verified")
  #   end
  # end
  
  

  # @impl true
  # def handle_event("connect-wallet", _params, socket) do
  #   IO.puts("connect-wallet")
  #   {:noreply, socket}
  # end

  @impl true
  def handle_event("effect_connected", _params, socket) do
    push_event(socket, "test", %{hello: "there"})
    {:noreply, assign(socket, connected: true)}
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
    IO.inspect(public_key, label: "public_key")
    {:noreply, assign(socket, address: public_key)}
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
