# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config
{:ok, pid} = Agent.start_link(fn -> %{} end)

config :grain,
  ecto_repos: [Grain.Repo]

config :grain, Grain.Scheduler,
  jobs: [
    {{:extended, "15 0-55/1 0-5/1 * *"}, {Grain.Tasks, :run, [pid]}},
    # {{:extended, "10 * * * *"}, {Grain.Tasks, :run, [pid]}},
    # {"* * * * *", {Grain.Tasks, :run, [pid]}}
    {"30 22 * * *", {Grain.Task, :grain_delete, []}}
    # {"30/30 0-3/1 * * *", {Grain.Tasks, :run, [pid]}}
  ]

import_config "#{Mix.env()}.exs"
