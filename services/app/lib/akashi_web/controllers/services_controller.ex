defmodule AkashiWeb.ServicesController do
  use AkashiWeb, :controller

  @url_siws "https://akashi-js.internal/siws"
  @url_sns "https://akashi-js.internal/sns"

  def siws(conn, _params) do
    conn
    |> put_status(:temporary_redirect)
    |> redirect(external: @url_siws)
    |> halt()
  end

  def sns(conn, %{address: address} = _params) do
    url = @url_sns <> "/#{address}"

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        conn
        |> put_status(:ok)
        |> json(%{domain: Enum.random(body.domains)})

      {:ok, %{status: status}} ->
        conn
        |> put_status(:bad_gateway)
        |> json(%{error: "Request error with status: #{status}"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: reason})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Unknown error"})
    end
  end
end
