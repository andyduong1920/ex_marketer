defmodule ExMarketerWeb.UserChannelTest do
  use ExMarketerWeb.ChannelCase, async: true

  alias ExMarketerWeb.UserSocket
  alias ExMarketerWeb.UserChannel
  alias ExMarketerWeb.KeywordView

  setup do
    token = Phoenix.Token.sign(@endpoint, "user socket", 1)

    {:ok, socket} = UserSocket |> connect(%{"token" => token})
    {:ok, _, socket} = socket |> subscribe_and_join(UserChannel, "user:1")

    %{socket: socket}
  end

  test "does NOT allow the user join to different user\"s topic", %{socket: socket} do
    assert {:error, :unauthorized} = socket |> join(UserChannel, "user:2")
  end

  test "notices the user when the search keyowrd is completed", %{socket: socket} do
    user = insert(:user, id: 1)
    keyword = insert(:keyword, id: 3, user: user)
    keyword_view = keyword_view(keyword)

    broadcast_from!(socket, "keyword_completed", %{keyword_id: 3})

    assert_push("keyword_completed", %{keyword_id: 3, keyword_view: ^keyword_view})
  end

  test "does NOT notice the user when the other user\"s search keyowrd is completed", %{
    socket: socket
  } do
    user = insert(:user, id: 2)
    keyword = insert(:keyword, id: 3, user: user)
    keyword_view = keyword_view(keyword)

    broadcast_from!(socket, "keyword_completed", %{keyword_id: 3})

    refute_push("keyword_completed", %{keyword_id: 3, keyword_view: ^keyword_view})
  end

  defp keyword_view(keyword) do
    Phoenix.View.render_to_string(KeywordView, "_keyword.html", %{
      keyword: keyword,
      recently_update: true
    })
  end
end
