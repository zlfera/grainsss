defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query, warn: false
  alias Grain.Repo

  alias Grain.Grains.Grain, as: G

  def list_grains do
    Repo.all(G)
  end
end
