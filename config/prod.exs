use Mix.Config

config :grain_web, GrainWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 5000],
  url: [host: "grain.gigalixirapp.com", port: 80],
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
import_config "prod.secret.exs"
config :logger, level: :info
