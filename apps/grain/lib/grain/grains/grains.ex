defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query

  alias Grain.Grains.Grain, as: Ggg

  def list_grains do
    Ggg
    |> Ecto.Query.where([l], l.latest_price != "0")
    |> Ecto.Query.order_by(desc: :inserted_at)
    |> Grain.Repo.all()
  end
end
