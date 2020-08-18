defmodule ExMarketerWeb.UserChannel do
  use ExMarketerWeb, :channel

  alias ExMarketer.Keyword
  alias Phoenix.View
  alias ExMarketerWeb.KeywordView

  intercept ["keyword_completed"]

  def join("user:" <> id, _params, socket) do
    if String.to_integer(id) === socket.assigns[:current_user_id] do
      {:ok, socket}
    else
      {:error, :unauthorized}
    end
  end

  # ExMarketerWeb.Endpoint.broadcast!
  def handle_out("keyword_completed", params, socket) do
    keyword_id = params.keyword_id
    keyword = Keyword.find(keyword_id)

    if socket.assigns[:current_user_id] === keyword.user_id do
      push(socket, "keyword_completed", %{
        keyword_id: keyword_id,
        keyword_view: build_keyword_view(keyword)
      })
    end

    {:noreply, socket}
  end

  defp build_keyword_view(keyword) do
    View.render_to_string(KeywordView, "_keyword.html", %{keyword: keyword, recently_update: true})
  end
end
