use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :grain_web, GrainWeb.Endpoint,
  # secret_key_base: "HceCH+9I1+d+0xn3AUdSTWX8HIUMmEybA5WH2gjo0sa0OPn41WKywIGx9FrNCRva"
  # secret_key_base: "${SECRET_KEY_BASE}",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE"),
  server: true
