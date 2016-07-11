defmodule Watercooler.LobbyController do
  use Watercooler.Web, :controller

  def index(conn, _params) do
    if current_user(conn) do
      render(conn, "index.html")
    else
      redirect(conn, to: "/")
    end
  end
end
