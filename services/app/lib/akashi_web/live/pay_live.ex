defmodule AkashiWeb.PayLive do
  @moduledoc false
  use AkashiWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Pay</h1>
    """
  end

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    {:ok, socket}
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
