# Since configuration is shared in umbrella projects, this file
# should only configure the :grain application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :grain, Grain.Repo,
  username: "wecwjsnz",
  password: "rsrLgvRN6qOhfXFDm3MQz9HwISL7TMve",
  database: "wecwjsnz",
  hostname: "baasu.db.elephantsql.com",
  # url:"postgres://wecwjsnz:rsrLgvRN6qOhfXFDm3MQz9HwISL7TMve@baasu.db.elephantsql.com:5432/wecwjsnz",
  pool_size: 5
