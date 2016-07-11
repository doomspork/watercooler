defmodule Watercooler.PageController do
  use Watercooler.Web, :controller

  def index(conn, _params) do
    if conn.cookies["username"] do
      redirect conn, to: "/lobby"
    else
      render conn, "index.html"
    end
  end
end
