defmodule AkashiWeb.ServicesController do
  use AkashiWeb, :controller

  @url_siws "https://akashi-js.internal/siws"
  @url_sns  "https://akashi-js.internal/sns"

  def siws(conn, _params) do
    conn 
    |> put_status(:temporary_redirect)
    |> redirect(external: @url_siws)  
    |> halt()
  end

  def sns(conn, %{address: address} = params) do
    url = @url_sns <> "/#{address}"
    case Req.get(url) do
      {:ok, %{status: 200, body: body}} -> {:ok, body.domains |> Enum.random()}
      {:ok, %{status: status}} -> {:error, "Request error with status: #{status}"}
      {:error, reason} -> {:error, reason}
      _ -> {:error, "Unknown error"}
    end
  end
end
