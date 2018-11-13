defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: G
  alias Grain.Grains.Grain, as: Gg

  def index(conn, _params) do
    # td_data = params["td_data"]

    # if td_data == nil do
    # @redis = Grain.where("latest_price != '0'") |> Repo.order(created_at: :desc)
    # else
    # {x, y} = td_data |> String.split(',')

    # if y == 'latest_price' || y == 'starting_price' do
    #   a = where("#{y} != '0'") |> Repo.order(created_at: :desc) |> Integer.minimum(y)
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

    grains = G.list_grains()
    render(conn, "index.html", grains: grains)
  end
end
