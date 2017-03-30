defmodule Listus.Router do
  use Listus.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :accepts, ["json"]
  end

  # scope "/", Listus do
  #   pipe_through :browser # Use the default browser stack
  #
  #   get "/", PageController, :index
  # end

  # Other scopes may use custom stacks.
  scope "/api", Listus do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/auth", Listus do
    pipe_through :auth
    resources "/", UserController, only: [:create]
  end
end
