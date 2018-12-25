# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :grain, Grain.Repo,
  # username: "postgres",
  # password: "postgres",
  # database: "grain_dev",
  # hostname: "localhost",
  url:
    "postgres://jglfexii:Oraq_oukbxRtsND6_6NMCo9nZz4g2Wnx@baasu.db.elephantsql.com:5432/jglfexii",
  pool_size: 5
