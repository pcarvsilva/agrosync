import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :recomendation_front, RecomendationFront.Repo,
  username: "postgres",
  password: "postgres",
  database: "recomendation_front_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :recomendation_front, RecomendationFrontWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "S6Smf1RgsCulB6XjuCMUJJEzrkxsfAmlD6RRHH8Xjh9lubnCbBPXSOdo0qYxdeS2",
  server: false

# In test we don't send emails.
config :recomendation_front, RecomendationFront.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
