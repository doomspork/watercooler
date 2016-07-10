defmodule Watercooler.PageController do
  use Watercooler.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
