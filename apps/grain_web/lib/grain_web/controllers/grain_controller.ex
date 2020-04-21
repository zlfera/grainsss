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
          "page_num" => ""
        }
      else
        params
      end

    {:ok, pid} = Agent.start_link(fn -> 0 end)

    {:ok, pid_num} =
      Agent.start_link(fn ->
        if params["page_num"] in ["", nil] do
          1
        else
          String.to_integer(params["page_num"])
        end
      end)

    {g, grains} = Gg.search_grain(params)
    render(conn, "inde.html", g: g, grains: grains, params: params, pid: pid, pid_num: pid_num)
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
