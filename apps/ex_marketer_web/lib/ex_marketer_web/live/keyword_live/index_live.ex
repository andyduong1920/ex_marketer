defmodule ExMarketerWeb.KeywordLive.IndexLive do
  use ExMarketerWeb, :live_view

  alias ExMarketer.Keyword

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: subscribe_pubsub_channel(current_user_id)

    socket =
      socket
      |> assign(:keywords, Keyword.list_by_user(current_user_id))
      |> assign(:changeset, Keyword.upload_keyword_changeset())
      |> assign(:trigger_submit, false)
      |> assign(:recently_update, false)

    {:ok, socket, temporary_assigns: [keywords: []]}
  end

  def handle_event("form_change", _params, socket) do
    {:noreply, assign(socket, trigger_submit: true)}
  end

  def handle_info({:keyword_completed, %{keyword_id: keyword_id}}, socket) do
    socket =
      socket
      |> assign(:recently_update, true)
      |> assign(:keywords, [Keyword.find(keyword_id)])

    {:noreply, socket}
  end

  defp subscribe_pubsub_channel(current_user_id) do
    Phoenix.PubSub.subscribe(
      ExMarketer.PubSub,
      "user_keyword:#{current_user_id}"
    )
  end
end
