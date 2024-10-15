import Config

# Charge les variables d'environnement depuis le fichier .env
Dotenv.load()

# Configure your database
config :time_manager_api, TimeManagerApi.Repo,
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  database: System.get_env("PGDATABASE"),
  hostname: System.get_env("PGHOST"),
  port: String.to_integer(System.get_env("PGPORT") || "5432"),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10


# Logger configuration
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  colors: [enabled: false]

# Configuration du serveur Phoenix
config :time_manager_api, TimeManagerApiWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "0wOkepZcmJ3JMkqGXHwsQrzz8z3o4WQdrbe1a74cJn+amJJ2qxLnRkDPmtkJoqz1",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:time_manager_api, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:time_manager_api, ~w(--watch)]}
  ]

# Configuration pour le live reload
config :time_manager_api, TimeManagerApiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/time_manager_api_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :time_manager_api, dev_routes: true

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client
config :swoosh, :api_client, false
