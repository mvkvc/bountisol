defmodule AkashiWeb.HomeLive do
  @moduledoc false
  use AkashiWeb, :live_view

  alias AkashiWeb.Presence

  @channel_topic "cursor_page"

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-pattern flex justify-center items-center h-screen w-screen">
      <ul class="list-none mt-9 max-h-full max-w-full" id="cursor" phx-hook="TrackClientCursor">
        <%= for user <- @users do %>
          <li
            style={"left: #{user.x}%; top: #{user.y}%"}
            class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="31"
              height="32"
              fill="none"
              viewBox="0 0 31 32"
            >
              <path
                fill={"url(#gradient-#{user.username})"}
                d="m.609 10.86 5.234 15.488c1.793 5.306 8.344 7.175 12.666 3.612l9.497-7.826c4.424-3.646 3.69-10.625-1.396-13.27L11.88 1.2C5.488-2.124-1.697 4.033.609 10.859Z"
              />
              <defs>
                <linearGradient
                  id={"gradient-#{user.username}"}
                  x1="-4.982"
                  x2="23.447"
                  y1="-8.607"
                  y2="25.891"
                  gradientUnits="userSpaceOnUse"
                >
                  <stop style={"stop-color: #{user.color}"} />
                  <stop offset="1" stop-color="#BDACFF" />
                </linearGradient>
              </defs>
            </svg>
            <span
              style={"background-color: #{user.color};"}
              class="mt-1 ml-4 px-1 text-sm text-white rounded-xl"
            >
              <%= user.username %>
            </span>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "LIVEVIEW PORT")
    username = MnemonicSlugs.generate_slug()
    color = RandomColor.hex()

    if connected?(socket) do
      Presence.track(self(), @channel_topic, socket.id, %{
        socket_id: socket.id,
        x: 50,
        y: 50,
        username: username,
        color: color
      })

      AkashiWeb.Endpoint.subscribe(@channel_topic)
    end

    initial_users =
      @channel_topic
      |> Presence.list()
      |> Enum.map(fn {_, data} -> List.first(data[:metas]) end)

    updated =
      socket
      |> assign(:username, username)
      |> assign(:users, initial_users)
      |> assign(:socket_id, socket.id)

    {:ok, updated}
  end

  @impl true
  def handle_event("cursor-move", %{"mouse_x" => x, "mouse_y" => y}, socket) do
    key = socket.id
    payload = %{x: x, y: y}

    metas =
      Presence.get_by_key(@channel_topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(self(), @channel_topic, key, metas)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{topic: "cursor_page", event: "presence_diff", payload: _payload}, socket) do
    users =
      @channel_topic
      |> Presence.list()
      |> Enum.map(fn {_, data} -> List.first(data[:metas]) end)

    updated =
      socket
      |> assign(users: users)
      |> assign(socket_id: socket.id)

    {:noreply, updated}
  end
end
