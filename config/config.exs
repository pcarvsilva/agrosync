# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :recomendation_front,
  ecto_repos: [RecomendationFront.Repo]

# Configures the endpoint
config :recomendation_front, RecomendationFrontWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RecomendationFrontWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RecomendationFront.PubSub,
  live_view: [signing_salt: "wCDHojgg"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :recomendation_front, RecomendationFront.Mailer, adapter: Swoosh.Adapters.Local

config :recomendation_front, RecomendationFront.Infrastructure.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "recommendation_front_eventstore_dev",
  hostname: "localhost",
  pool_size: 10

config :recomendation_front, event_stores: [RecomendationFront.Infrastructure.EventStore]

config :recomendation_front, RecomendationFront.Infrastructure.EventStore.Dispatcher,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: RecomendationFront.Infrastructure.EventStore
  ]

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/recomendation_front/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.1.0",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/recomendation_front/assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
