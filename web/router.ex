defmodule Watercooler.Router do
  use Watercooler.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Watercooler do
    pipe_through [:browser, :browser_session]

    get "/", PageController, :index
    get "/lobby", LobbyController, :index
    get "/signup", UserController, :new
    post "/signup", UserController, :create
    get "/logout", AuthController, :delete
  end

  scope "/auth", Watercooler do
    pipe_through [:browser]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
  end
end
