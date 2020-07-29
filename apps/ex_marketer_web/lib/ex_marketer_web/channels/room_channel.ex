defmodule ExMarketerWeb.RoomChannel do
  use ExMarketerWeb, :channel

  intercept ["user_joined"]

  def join("room:lobby", _params, socket) do
    {:ok, socket}
  end

  def handle_out("user_joined", params, socket) do
    unless socket.assigns[:current_user_id] === params.id do
      push(socket, "user_joined", %{email: params.email})
    end

    {:noreply, socket}
  end
end
