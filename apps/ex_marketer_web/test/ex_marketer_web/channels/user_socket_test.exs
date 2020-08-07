defmodule ExMarketerWeb.UserSocketTest do
  use ExMarketerWeb.ChannelCase, async: true

  alias ExMarketerWeb.UserSocket

  test "authenticates with valid token" do
    token = Phoenix.Token.sign(@endpoint, "user socket", 1)

    assert {:ok, socket} = UserSocket |> connect(%{"token" => token})
    assert socket.assigns.current_user_id == 1
  end

  test "does NOT authenticate with invalid token" do
    token = Phoenix.Token.sign(@endpoint, "invalid", 1)

    assert :error = UserSocket |> connect(%{"token" => token})
  end
end
