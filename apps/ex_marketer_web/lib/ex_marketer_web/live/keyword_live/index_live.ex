defmodule ExMarketerWeb.KeywordLive.IndexLive do
  use ExMarketerWeb, :live_view

  alias ExMarketer.Keyword

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: subscribe_pubsub_channel(current_user_id)

    {
      :ok,
      assign(socket, :keywords, Keyword.list_by_user(current_user_id)),
      temporary_assigns: [keywords: []]
    }
  end

  def handle_info({:keyword_completed, %{keyword_id: keyword_id}}, socket) do
    {:noreply, assign(socket, :keywords, [Keyword.find(keyword_id)])}
  end

  defp subscribe_pubsub_channel(current_user_id) do
    Phoenix.PubSub.subscribe(
      ExMarketer.PubSub,
      "user_keyword:#{current_user_id}"
    )
  end
end
