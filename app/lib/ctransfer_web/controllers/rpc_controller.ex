defmodule CTransferWeb.RPCController do
  use CTransferWeb, :controller

  def webhook(conn, params) do
    IO.inspect(params)

    put_status(conn, :ok)
  end
end
