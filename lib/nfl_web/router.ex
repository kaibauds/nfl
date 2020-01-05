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

    get "/download", RushingController, :download

    resources "", RushingController
  end
end
