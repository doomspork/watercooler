defmodule Watercooler.UserController do
  use Watercooler.Web, :controller

  alias Watercooler.User

  def new(conn, _params) do
    user = get_session(conn, :new_user)
    if user do
      changeset = User.changeset(user)
      render(conn, "new.html", changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(HelloPhoenix.ErrorView, "404.html")
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account successfully created.")
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: lobby_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
