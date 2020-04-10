defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: Gg

  def inde(conn, params) do
    params =
      if params == %{} do
        %{
          "page" => "",
          "year" => "",
          "city1" => "",
          "city2" => "",
          "city3" => "",
          "limit" => "",
          "fenye" => ""
        }
      else
        params
      end

    {:ok, pid} = Agent.start_link(fn -> 0 end)
    {:ok, fenyepid} = Agent.start_link(fn -> 0 end)
    {g, grains} = Gg.search_grain(params)
    render(conn, "inde.html", g: g, grains: grains, params: params, pid: pid, fenye: fenyepid)
  end

  def index(conn, params) do
    grains =
      if Map.has_key?(params, "td_data") && params["td_data"] != "" do
        [x, y] = params["td_data"] |> String.split(",")
        Gg.grains_list(x, y)
      else
        if Map.has_key?(params, "search") do
          Gg.search_grains(params["search"])
        else
          Gg.list_grains()
        end
      end

    {:ok, pid} = Agent.start_link(fn -> 0 end)
    render(conn, "index.html", grains: grains, pid: pid)
  end
end
