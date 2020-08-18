defmodule ExMarketerWeb.RoomChannelTest do
  use ExMarketerWeb.ChannelCase, async: true

  alias ExMarketerWeb.UserSocket
  alias ExMarketerWeb.RoomChannel

  setup do
    user = insert(:user, id: 1, email: "email@example.com")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)

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

  test "broadcasting presence" do
    user_meta_data = %{email: "email@example.com"}

    assert_push "presence_state", user_meta_data
    assert_broadcast "presence_diff", user_meta_data
  end
end
