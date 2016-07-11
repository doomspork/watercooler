defmodule Watercooler.RoomChannel do
  use Watercooler.Web, :channel

  def join("room:lobby", msg, socket) do
    if authorized?(msg) do
      socket = assign(socket, :user, msg["user"])
      send(self, {:after_join, msg})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("rooms:" <> _unknown, _msg, _socket) do
    {:error, %{reason: "unknown room"}}
  end

  def handle_in("ping", msg, socket) do
    {:reply, {:ok, msg}, socket}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: socket.assigns[:user]}
    {:noreply, socket}
  end

  def handle_in("new:msg", msg, socket) do
    user = socket.assigns[:user]
    broadcast! socket, "new:msg", %{user: user, body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, user)}
  end

  def terminate(_reason, socket) do
    broadcast! socket, "user:exited", %{user: socket.assigns[:user]}
    :ok
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
