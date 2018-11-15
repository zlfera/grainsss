defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  import Ecto.Query, warn: false
  alias Grain.Grains, as: Gg
  alias Grain.Grains.Grain, as: Ggg

  def index(conn, params) do
    grains =
      if Map.has_key?(params, "td_data") do
        Ggg
        |> Ecto.Query.where([l], l.latest_price != "0")
        |> Ecto.Query.order_by(desc: :inserted_at)
        |> Grain.Repo.all()

        # else
        # [x, y] = params.td_data |> String.split(",")

        # if y == "latest_price" || y == "starting_price" do
        #  a = where("#{y} != '0'") |> Repo.order(created_at: :desc) |> Integer.minimum(y)
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
      else
        Gg.list_grains()
      end

    render(conn, "index.html", grains: grains)
  end
end
