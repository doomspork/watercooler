defmodule Watercooler.RoomChannel do
  use Watercooler.Web, :channel

  def join("room:lobby", %{"guardian_token" => token}, socket) do
    case Guardian.Phoenix.Socket.sign_in(socket, token) do
      {:ok, authed_socket, _guardian_params} ->
        send(self, :after_join)
        {:ok, authed_socket}
      {:error, _reason} ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def join(_unknown, _msg, _socket) do
    {:error, %{reason: "unknown room"}}
  end

  def handle_info(:after_join, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    broadcast! socket, "user:entered", %{user: user.username}
    {:noreply, socket}
  end

  def handle_in("ping", msg, socket) do
    {:reply, {:ok, msg}, socket}
  end

  def handle_in("new:msg", msg, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    broadcast! socket, "new:msg", %{avatar: user.avatar, body: msg["body"], username: user.username}
    {:reply, {:ok, %{msg: msg["body"]}}, socket}
  end

  def terminate(_reason, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    broadcast! socket, "user:exited", %{user: user.username}
    :ok
  end
end
