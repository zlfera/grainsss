defmodule Grain.Grains do
  @moduledoc """
  The Grains context.
  """

  import Ecto.Query

  alias Grain.Grains.Grain, as: Ggg
  alias Grain.Repo, as: Gr

  def year(g, year) do
    if year in ["", nil] do
      g
    else
      where(g, [a], a.year == ^year)
    end
  end

  def city(g, city) do
    if String.trim(city) in ["", nil] do
      g
    else
      city = "%#{city}%"

      or_where(g, [a], like(a.address, ^city))
      |> or_where([a], like(a.storage_depot_name, ^city))
    end
  end

  def limit_num(g, l) do
    if l in ["", nil] do
      limit(g, 100)
    else
      l = String.to_integer(l)
      limit(g, ^l)
    end
  end

  def page(g, params) do
    l =
      if params["limit"] in ["", nil] do
        100
      else
        String.to_integer(params["limit"])
      end

    fenye =
      if params["fenye"] in ["", nil] do
        0
      else
        String.to_integer(params["fenye"]) + 1
      end

    if params["page"] == "" || !Map.has_key?(params, "page") do
      g
      |> offset(^fenye)
      |> limit_num(params["limit"])
    else
      page = params["page"]
      page = String.to_integer(page) * l

      g
      |> offset(^page)
      |> limit_num(params["limit"])
    end
  end

  def search_grain(params) do
    gg =
      Ggg
      |> order_by(desc: :inserted_at)
      |> city(params["city1"])
      |> city(params["city2"])
      |> city(params["city3"])
      |> year(params["year"])

    ggg = page(gg, params)
    {length(Gr.all(gg)), Gr.all(ggg)}
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
