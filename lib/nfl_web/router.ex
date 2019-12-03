defmodule NflWeb.Router do
  use NflWeb, :router

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

  scope "/", NflWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/stats", NflWeb do
    pipe_through :browser

    resources "/rushing_data", RushingController
  end

  # Other scopes may use custom stacks.
  # scope "/api", NflWeb do
  #   pipe_through :api
  # end
end
