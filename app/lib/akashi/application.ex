defmodule Akashi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AkashiWeb.Telemetry,
      Akashi.Repo,
      {DNSCluster, query: Application.get_env(:akashi, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Akashi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Akashi.Finch},
      # Start a worker by calling: Akashi.Worker.start_link(arg)
      # {Akashi.Worker, arg},
      # Start to serve requests, typically the last entry
      AkashiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Akashi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AkashiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
