defmodule AkashiWeb.RPCController do
  use AkashiWeb, :controller

  def webhook(conn, params) do
    IO.inspect(params)

    put_status(conn, :ok)
  end
end
