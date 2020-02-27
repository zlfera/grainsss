defmodule ApiWeb.ApiController do
  use ApiWeb, :controller

  def index(conn, _params) do
    grains = Grain.Grains.list_grains()
    json(conn, grains)
  end
end
