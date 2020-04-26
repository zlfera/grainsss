use Mix.Config

config :grain_web, GrainWeb.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
config :grain, Grain.Repo,
  username: "postgres",
  password: "postgres",
  database: "grain_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :warn
