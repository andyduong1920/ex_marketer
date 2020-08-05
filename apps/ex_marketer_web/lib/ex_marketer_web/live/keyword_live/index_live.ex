defmodule ExMarketerWeb.KeywordLive.IndexLive do
  use ExMarketerWeb, :live_view

  alias ExMarketer.Keyword
  alias ExMarketerWeb.KeywordView

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    if connected?(socket), do: subscribe_pubsub_channel(current_user_id)

    socket =
      socket
      |> assign_new(:current_user_id, fn -> current_user_id end)
      |> assign(:keywords, Keyword.list_by_user(current_user_id))
      |> assign(:in_progress_keyword_stats, Keyword.in_progress_keyword_stats(current_user_id))
      |> assign(:changeset, Keyword.upload_keyword_changeset())
      |> assign(:trigger_submit, false)
      |> assign(:recently_result, [])
      |> assign(:recently_search, false)

    {:ok, socket}
  end

  def handle_event("form_upload_submit", _params, socket) do
    socket =
      socket
      |> assign(:recently_result, [])
      |> assign(:trigger_submit, true)

    {:noreply, socket}
  end

  def handle_event("form_search", %{"search" => %{"keyword_name" => keyword_name}}, socket) do
    socket =
      socket
      |> assign(:recently_search, true)
      |> assign(
        :keywords,
        Keyword.search_by_keyword_name(keyword_name, socket.assigns.current_user_id)
      )

    {:noreply, socket}
  end

  def handle_info({:keyword_completed, %{keyword_id: keyword_id}}, socket) do
    keyword = Keyword.find(keyword_id)

    socket =
      socket
      |> assign(
        :in_progress_keyword_stats,
        Keyword.in_progress_keyword_stats(socket.assigns.current_user_id)
      )
      |> update(:recently_result, &(&1 ++ [keyword]))
      |> update(:keywords, &update_keywords(&1, keyword))

    {:noreply, socket}
  end

  defp update_keywords(keywords, keyword) do
    if keyword_index = Enum.find_index(keywords, &(&1.id === keyword.id)) do
      keywords |> List.replace_at(keyword_index, keyword)
    else
      keywords
    end
  end

  defp subscribe_pubsub_channel(current_user_id) do
    Phoenix.PubSub.subscribe(
      ExMarketer.PubSub,
      "user_keyword:#{current_user_id}"
    )
  end
end
