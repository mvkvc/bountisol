defmodule AkashiWeb.UserSessionController do
  use AkashiWeb, :controller

  alias Akashi.SIWS

  # alias Akashi.Accounts
  alias AkashiWeb.UserAuth

  # Create a new controller for validation of the signature
  # When validating, if correct then attach latest to the user
  # The user will then log in with their address and signature and if it matches the latest then they are logged in
  # Use Jason to pass around maps

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"message" => message, "address" => address, "signature" => signature} = params, info) do
    user = SIWS.verify_signature(%{address: address, message: message, signature: signature})

    if user do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, params)
    else
      conn
      |> put_flash(:error, "Invalid signature.")
      |> redirect(to: ~p"/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
