# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :grain,
  ecto_repos: [Grain.Repo]

config :grain, Grain.Scheduler,
  jobs: [
    # {"31 24 * * *", {Grain.Tasks, :run, []}},
    # {"* * * * *", {Grain.Tasks, :run, []}}
    {"31 24-2/2 * * *", {Grain.Tasks, :run, []}}
  ]

import_config "#{Mix.env()}.exs"
