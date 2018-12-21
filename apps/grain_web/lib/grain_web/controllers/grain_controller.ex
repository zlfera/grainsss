defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: Gg

  def index(conn, params) do
    grains =
      if Map.has_key?(params, "td_data") && params["td_data"] != "" do
        [x, y] = params["td_data"] |> String.split(",")
        Gg.grains_list(x, y)
      else
        if Map.has_key?(params, "search") do
          Gg.search_grains(params)
        else
          Gg.list_grains()
        end
      end

    render(conn, "index.html", grains: grains)
  end
end
