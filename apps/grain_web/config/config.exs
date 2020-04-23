# Since configuration is shared in umbrella projects, this file
# should only configure the :grain_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :grain_web,
  ecto_repos: [Grain.Repo],
  generators: [context_app: :grain]

# Configures the endpoint
config :grain_web, GrainWeb.Endpoint,
  instrumenters: [NewRelic.Phoenix.Instrumenter],
  url: [host: "localhost"],
  secret_key_base: "J1yC9GgAwF/xY/ql9RVS8JNvE2Ggq4d8hrVhcumk9mFl4KrAXtOpQ4Au6GA+T6fq",
  render_errors: [view: GrainWeb.ErrorView, accepts: ~w(html json)],
  # pubsub: [name: GrainWeb.PubSub, adapter: Phoenix.PubSub.PG2]
  pubsub_server: GrainWeb.PubSub

# Import environment specific config. This must remain at the bottom
# of thisname file so it overrides the configuration defined above.
config :new_relic_agent,
  app_name: "Grain",
  license_key: "ee9c2eabf9a8054364cfc885b768dc549c1ee5c6"

import_config "#{Mix.env()}.exs"
