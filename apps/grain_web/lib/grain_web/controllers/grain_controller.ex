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

        # if y == "latest_price" || y == "starting_price" do
        case y do
          "latest_price" ->
            # Gg.list_grains()
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

        # a = where("#{y} != '0'") |> Repo.order(created_at: :desc) |> Integer.minimum(y)
        #   @redis = Grain.where("#{y} = '#{a}'")

        # @redis = Grain.where("#{y} <= '#{x}'").where("latest_price != '0'").where("latest_price != '拍卖'").order(created_at: :desc)
        # else
        #   if y == 'address' do
        #     {x, _} = x |> String.split('(')
        #   end

        #   @redis =
        #     Grain.where("#{y} = '#{x}'")
        #     |> Repo.where("latest_price != '0'")
        #     |> Repo.order(created_at: :desc)
        # end
        # end
        # else
        # Gg.list_grains()
      end

    render(conn, "index.html", grains: grains)
  end
end
