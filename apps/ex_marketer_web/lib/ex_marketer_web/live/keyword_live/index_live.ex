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
      |> assign(:recently_search, false)
      |> assign(:keyword, nil)
      |> assign(:selected_keyword, nil)

    {:ok, socket}
  end

  def handle_params(%{"id" => keyword_id}, _, socket) do
    keyword = Keyword.find(keyword_id)

    socket =
      if keyword.user_id == socket.assigns.current_user_id do
        socket
        |> assign(:page_title, keyword.keyword)
        |> assign(:keyword, keyword)
        |> assign(:selected_keyword, keyword.id)
      else
        socket
        |> put_flash(:error, "Not Found")
        |> push_patch(to: Routes.keyword_index_path(socket, :index))
      end

    {:noreply, socket}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("form_upload_submit", _params, socket) do
    socket =
      socket
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
