defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: Gg

  def index(conn, params) do
    grains =
      if Map.has_key?(params, "td_data") do
        [x, y] = params["td_data"] |> String.split(",")
        Gg.grains_list(x, y)
      else
        Gg.list_grains()
      end

    render(conn, "index.html", grains: grains)
  end
end
