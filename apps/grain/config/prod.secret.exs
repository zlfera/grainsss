use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).

# Configure your database
config :grain, Grain.Repo,
  url: "${DATABASE_URL}",
  # url: System.get_env("DATABASE_URL"),
  # url: "postgres://jglfexii:Oraq_oukbxRtsND6_6NMCo9nZz4g2Wnx@baasu.db.elephantsql.com:5432/jglfexii",
  # username: "wecwjsnz",
  # password: "rsrLgvRN6qOhfXFDm3MQz9HwISL7TMve",
  # database: "wecwjsnz",
  # hostname: "baasu.db.elephantsql.com",
  ssl: true,
  pool_size: 3
