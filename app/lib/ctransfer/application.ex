defmodule CTransfer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Oban.Telemetry.attach_default_logger()

    children = [
      CTransferWeb.Telemetry,
      CTransfer.Repo,
      {DNSCluster, query: Application.get_env(:ctransfer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CTransfer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: CTransfer.Finch},
      # Start a worker by calling: CTransfer.Worker.start_link(arg)
      # {CTransfer.Worker, arg},
      # Start to serve requests, typically the last entry
      CTransferWeb.Endpoint,
      CTransferWeb.Presence,
      {Oban, Application.fetch_env!(:ctransfer, Oban)},
      Portboy.child_pool(:solana, {System.find_executable("node"), [Path.join(:code.priv_dir(:ctransfer), "/ports/solana/out/main.js")]}, 5, 2)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CTransfer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CTransferWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
