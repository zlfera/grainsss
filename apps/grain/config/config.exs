# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :grain,
  ecto_repos: [Grain.Repo]

config :grain, Grain.Scheduler,
  jobs: [
    {{:extended, "5 0-59/1 0-8/1 * *"}, {Grain.Tasks.Tasks, :run, []}},
    # {{:extended, "10 * * * *"}, {Grain.Tasks, :run, [pid]}},
    # {"* * * * *", {Grain.Tasks, :run, [pid]}}
    {"0 22 * * *", {Grain.Task, :grain_delete, []}}
    # {"30/30 0-3/1 * * *", {Grain.Tasks, :run, [pid]}}
  ]

import_config "#{Mix.env()}.exs"
