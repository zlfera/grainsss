use Mix.Config

config :grain_web, GrainWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  # secret_key_base: "HceCH+9I1+d+0xn3AUdSTWX8HIUMmEybA5WH2gjo0sa0OPn41WKywIGx9FrNCRva"
  # secret_key_base: "${SECRET_KEY_BASE}",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :grain, Grain.Repo,
  # url: "${DATABASE_URL}",
  url: System.get_env("DATABASE_URL"),
  # url: "postgres://jglfexii:Oraq_oukbxRtsND6_6NMCo9nZz4g2Wnx@baasu.db.elephantsql.com:5432/jglfexii",
  # username: "wecwjsnz",
  # password: "rsrLgvRN6qOhfXFDm3MQz9HwISL7TMve",
  # database: "wecwjsnz",
  # hostname: "baasu.db.elephantsql.com",
  ssl: true,
  pool_size: 3
