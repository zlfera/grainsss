defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query

  alias Grain.Grains.Grain, as: Ggg
  alias Grain.Repo, as: Gr

  def search_grain(params) do
    limit =
      if params["limit"] == "" do
        200
      else
        String.to_integer(params["limit"])
      end

    city1 =
      if params["city1"] == "" do
        "%九江%"
      else
        "%#{params["city1"]}%"
      end

    city2 =
      if params["city2"] == "" do
        "%九江%"
      else
        "%#{params["city2"]}%"
      end

    city3 =
      if params["city3"] == "" do
        "%九江%"
      else
        "%#{params["city3"]}%"
      end

    year =
      if params["year"] == "" do
        "2016"
      else
        params["year"]
      end

    Ggg
    |> limit(^limit)
    |> where([a], like(a.address, ^city1))
    |> or_where([a], like(a.address, ^city2))
    |> or_where([a], like(a.address, ^city3))
    |> where([a], a.year == ^year)
    |> Gr.all()
  end

  def search_grains(user_input) do
    Ggg
    |> order_by(desc: :inserted_at)
    |> Ecto.Query.limit(5000)
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
