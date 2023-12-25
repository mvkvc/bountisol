# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ctransfer,
  network: :devnet,
  ecto_repos: [CTransfer.Repo],
  generators: [timestamp_type: :utc_datetime]

config :ctransfer, CTransfer.Repo, types: CTransfer.PostgrexTypes

# Configures the endpoint
config :ctransfer, CTransferWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  # adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [html: CTransferWeb.ErrorHTML, json: CTransferWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: CTransfer.PubSub,
  live_view: [signing_salt: "gHc3jy5v"]

config :ctransfer, Oban,
  repo: CTransfer.Repo,
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)}],
  queues: [default: 10, mailers: 20]


# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ctransfer, CTransfer.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
# config :esbuild,
#   version: "0.17.11",
#   default: [
#     args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#     cd: Path.expand("../assets", __DIR__),
#     env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
#   ]

# Configure tailwind (the version is required)
# config :tailwind,
#   version: "3.3.2",
#   default: [
#     args: ~w(
#       --config=tailwind.config.js
#       --input=css/app.css
#       --output=../priv/static/assets/app.css
#     ),
#     cd: Path.expand("../assets", __DIR__)
#   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
