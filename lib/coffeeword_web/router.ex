defmodule CoffeewordWeb.Router do
  use CoffeewordWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug CoffeewordWeb.Auth, context: Coffeeword.Accounts
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CoffeewordWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", CoffeewordWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/users", UserController
  end

  scope "/publications", CoffeewordWeb.Publications, as: :publications do
    pipe_through [:browser, :authenticate_user]

    resources "/articles", ArticleController
  end


  # Other scopes may use custom stacks.
  # scope "/api", CoffeewordWeb do
  #   pipe_through :api
  # end
end
