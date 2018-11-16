# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :grain,
  ecto_repos: [Grain.Repo]

config :grain, Grain.Scheduler,
  timezone: "Asia/Shanghai",
  jobs: [
    {{:extended, "*/10 30 24-2 * *"}, {Grain.Tasks, :run, []}}
    # {"* * * * *", {Grain.Tasks, :run, []}}
    # {"30 0-2/1 * * *", {Grain.Tasks, :run, []}}
  ]

import_config "#{Mix.env()}.exs"
