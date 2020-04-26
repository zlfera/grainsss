use Mix.Config

config :grain_web, GrainWeb.Endpoint,
  url: [host: "grain.gigalixirapp.com", port: 80],
  # server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info
import_config "prod.secret.exs"
