defmodule ExMarketerWeb.RoomChannel do
  use ExMarketerWeb, :channel

  alias ExMarketerWeb.Presence

  intercept ["user_joined"]

  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  # Listen from Phoenix.Socket.Broadcast
  def handle_out("user_joined", params, socket) do
    unless socket.assigns[:current_user_id] === params.id do
      push(socket, "user_joined", %{email: params.email})
    end

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    user = ExMarketer.Accounts.get_user!(socket.assigns[:current_user_id])

    {:ok, _} =
      Presence.track(socket, socket.assigns[:current_user_id], %{
        email: user.email,
        last_seen_at: inspect(System.system_time(:second))
      })

    push(socket, "presence_state", Presence.list(socket))

    {:noreply, socket}
  end
end
