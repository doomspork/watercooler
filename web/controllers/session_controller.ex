defmodule Watercooler.SessionController do
  use Watercooler.Web, :controller

  def create(conn, %{"login" => %{"username" => username}}) do
    conn
    |> put_resp_cookie("username", username)
    |> redirect(to: "/lobby")
  end

  def delete(conn, _params) do
    conn
    |> delete_resp_cookie("username")
    |> redirect(to: "/")
  end
end

