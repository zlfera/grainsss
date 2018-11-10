# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :grain,
  ecto_repos: [Grain.Repo]

config :grain, Grain.Scheduler,
  jobs: [
    {"35 8 * * *", {Grain.Tasks, :run, []}}
  ]

import_config "#{Mix.env()}.exs"
