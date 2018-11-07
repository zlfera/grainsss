defmodule Grain.Repo do
  use Ecto.Repo,
    otp_app: :grain,
    adapter: Ecto.Adapters.Postgres
end
