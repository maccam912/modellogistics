defmodule ModellogisticsWeb.Router do
  use ModellogisticsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ModellogisticsWeb.Plugs.StartTimer
  end

  scope "/ui", ModellogisticsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/", ModellogisticsWeb do
    pipe_through :api

    get "/ping", PingController, :index
  end
end
