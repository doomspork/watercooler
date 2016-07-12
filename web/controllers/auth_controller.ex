defmodule Watercooler.AuthController do
  use Watercooler.Web, :controller

  plug Ueberauth

  alias Watercooler.User
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    auth
    |> User.from_auth
    |> user_response(conn)
  end

  def user_response(%User{id: nil} = user, conn) do
    conn
    |> put_session(:new_user, user)
    |> redirect(to: "/signup")
  end
  def user_response(user, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/lobby")
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> put_flash(:error, "You must be logged in!")
    |> redirect(to: "/")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> put_flash(:error, "You do not have adequate permission!")
    |> redirect(to: "/")
  end
end

