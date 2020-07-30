defmodule ExMarketerWeb.UserChannel do
  use ExMarketerWeb, :channel

  alias ExMarketer.Keyword
  alias Phoenix.View
  alias ExMarketerWeb.KeywordView

  def join("user:" <> id, _params, socket) do
    if String.to_integer(id) === socket.assigns[:current_user_id] do
      {:ok, socket}
    else
      {:error, :unauthorized}
    end
  end

  # Listen from Phoenix.Pubsub.Broadcast
  def handle_info({:keyword_completed, params}, socket) do
    keyword_id = params.keyword_id

    push(socket, "keyword_completed", %{
      keyword_id: keyword_id,
      keyword_view: build_keyword_view(keyword_id)
    })

    {:noreply, socket}
  end

  defp build_keyword_view(keyword_id) do
    keyword = Keyword.find(keyword_id)

    View.render_to_string(KeywordView, "_keyword.html", %{keyword: keyword, recently_update: true})
  end
end
