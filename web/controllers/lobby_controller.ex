defmodule Watercooler.LobbyController do
  use Watercooler.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, [handler: Watercooler.AuthController]

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
