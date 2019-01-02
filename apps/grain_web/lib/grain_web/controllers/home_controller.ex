defmodule GrainWeb.HomeController do
  use GrainWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
