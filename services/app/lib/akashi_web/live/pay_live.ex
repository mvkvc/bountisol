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
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
