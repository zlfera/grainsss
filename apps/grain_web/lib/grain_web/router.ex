defmodule GrainWeb.Router do
  use GrainWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrainWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/grains", GrainController, :index
    # post "/grains", GrainController, :index
    get "/home", HomeController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrainWeb do
  #   pipe_through :api
  # end
end
