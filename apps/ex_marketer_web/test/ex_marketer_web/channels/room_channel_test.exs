defmodule ExMarketerWeb.RoomChannelTest do
  use ExMarketerWeb.ChannelCase, async: true

  alias ExMarketerWeb.UserSocket
  alias ExMarketerWeb.RoomChannel

  setup do
    token = Phoenix.Token.sign(@endpoint, "user socket", 1)

    {:ok, socket} = UserSocket |> connect(%{"token" => token})
    {:ok, _, socket} = socket |> subscribe_and_join(RoomChannel, "room:lobby")

    %{socket: socket}
  end

  test "notices the new user login", %{socket: socket} do
    broadcast_from!(socket, "user_joined", %{id: 2, email: "new_joiner@email.com"})

    assert_push "user_joined", %{email: "new_joiner@email.com"}
  end

  test "does NOT notice the user itself login", %{socket: socket} do
    broadcast_from!(socket, "user_joined", %{id: 1, email: "same_user@email.com"})

    refute_push "user_joined", %{email: "same_user@email.com"}
  end
end
