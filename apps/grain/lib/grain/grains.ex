defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query

  alias Grain.Grains.Grain, as: Ggg
  alias Grain.Repo, as: Gr

  def search_grains(user_input) do
    Ggg
    |> order_by(desc: :inserted_at)
    # |> Ecto.Query.limit(3000)
    # |> offset(i)
    |> Gr.all()
    |> Enum.reject(&(String.match?(&1.address, ~r/#{user_input}/) == false))
  end

  def list_grains do
    Ggg
    |> limit(3000)
    |> where([l], l.latest_price != "0")
    |> order_by(desc: :inserted_at)
    |> Gr.all()
  end

  def grains_list(x, y) do
    case y do
      "latest_price" ->
        Ggg
        |> where([l], l.latest_price != "0")
        |> limit(3000)
        |> order_by(desc: :inserted_at)
        |> Grain.Repo.all()

      "starting_price" ->
        [f] = from(p in Ggg, select: min(p.starting_price)) |> Gr.all()

        Ggg
        |> where(starting_price: ^f)
        # |> Ecto.Query.where([g], g.latest_price != "0")
        |> order_by(desc: :inserted_at)
        |> Gr.all()

      "year" ->
        Ggg
        |> where(year: ^x)
        |> limit(3000)
        # |> Ecto.Query.where([g], g.latest_price != "0")
        |> order_by(desc: :inserted_at)
        |> Gr.all()

      "address" ->
        [xx, _] = x |> String.split("(")

        Ggg
        |> where(address: ^xx)
        |> limit(3000)
        # |> Ecto.Query.where([g], g.latest_price != "0")
        |> order_by(desc: :inserted_at)
        |> Gr.all()

      "variety" ->
        Ggg
        |> where(variety: ^x)
        |> limit(3000)
        # |> Ecto.Query.where([g], g.latest_price != "0")
        |> order_by(desc: :inserted_at)
        |> Gr.all()
    end
  end
end
