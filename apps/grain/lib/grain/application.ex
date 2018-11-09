defmodule Grain.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Supervisor
  use Application

  def start(_type, _args) do
    children = [
      Grain.Repo,
      # worker(Grain.Scheduler, []),
      worker(Grain.Task, [])
      #    worker(Grain.Tasks, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Grain.Supervisor)
  end
end
