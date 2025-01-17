import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# config :time_manager_api, TimeManagerApi.Repo,
#   username: System.get_env("DB_USERNAME"),
#   password: System.get_env("DB_PASSWORD"),
#   hostname: System.get_env("DB_HOSTNAME"),
#   database: "time_manager_api_test#{System.get_env("MIX_TEST_PARTITION")}",
#   pool: Ecto.Adapters.SQL.Sandbox,
#   pool_size: System.schedulers_online() * 2

config :time_manager_api, TimeManagerApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "db",
  database: "time_manager_api_dev",
  port: "5432",
  stacktrace: true,
 show_sensitive_data_on_connection_error: true,
 pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_manager_api, TimeManagerApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "oNRctn/2MudWqFQy9+aVL4pP4TdGbbPRRJcVcxvstpE3GU2VpQ4S9DnNgSDKJXPj",
  server: false

# In test we don't send emails
config :time_manager_api, TimeManagerApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
