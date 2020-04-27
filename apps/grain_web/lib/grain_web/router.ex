defmodule GrainWeb.Router do
  use GrainWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :fetch_live_flash
    # plug :put_root_layout, {GrainWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrainWeb do
    pipe_through :browser
    # live "/", PageLive, :index
    get "/", PageController, :index
    get "/grains", GrainController, :inde
    get "/grain", GrainController, :index
    get "/home", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrainWeb do
  #   pipe_through :api
  # end
  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router
    import Plug.BasicAuth

    pipeline :admins_only do
      plug :basic_auth, username: "admin", password: "13579"
    end

    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard", metrics: GrainWeb.Telemetry
    end
  end
end
