defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: Gg
  alias Grain.Grains.Grain, as: Ggg
  alias Grain.Repo, as: Gr
  import Ecto.Query

  def index(conn, params) do
    grains =
      if !Map.has_key?(params, "td_data") do
        Gg.list_grains()
      else
        [x, y] = params["td_data"] |> String.split(",")

        case y do
          "latest_price" ->
            Ggg
            |> Ecto.Query.where([l], l.latest_price != "0")
            |> Ecto.Query.order_by(desc: :inserted_at)
            |> Grain.Repo.all()

          "starting_price" ->
            [f] = Ecto.Query.from(p in Ggg, select: min(p.starting_price)) |> Gr.all()

            Ggg
            |> Ecto.Query.where(starting_price: ^f)
            |> Ecto.Query.where([g], g.latest_price != "0")
            |> Ecto.Query.order_by(desc: :inserted_at)
            |> Gr.all()

          "year" ->
            Ggg
            |> Ecto.Query.where(year: ^x)
            |> Ecto.Query.where([g], g.latest_price != "0")
            |> Ecto.Query.order_by(desc: :inserted_at)
            |> Gr.all()

          "address" ->
            [xx, _] = x |> String.split("(")

            Ggg
            |> Ecto.Query.where(address: ^xx)
            |> Ecto.Query.where([g], g.latest_price != "0")
            |> Ecto.Query.order_by(desc: :inserted_at)
            |> Gr.all()

          "variety" ->
            Ggg
            |> Ecto.Query.where(variety: ^x)
            |> Ecto.Query.where([g], g.latest_price != "0")
            |> Ecto.Query.order_by(desc: :inserted_at)
            |> Gr.all()
        end
      end

    render(conn, "index.html", grains: grains)
  end
end
