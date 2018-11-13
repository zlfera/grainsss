defmodule GrainWeb.GrainController do
  use GrainWeb, :controller
  alias Grain.Grains, as: G
  alias Grain.Grains.Grain, as: Gg

  def index(conn, _params) do
    grains = G.list_grains()
    render(conn, "index.html", grains: grains)
  end
end
