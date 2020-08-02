defmodule ExMarketerWeb.KeywordLive.IndexLive do
  use ExMarketerWeb, :live_view

  alias ExMarketer.Keyword

  def mount(_params, %{"current_user_id" => current_user_id}, socket) do
    {:ok, assign(socket, :keywords, Keyword.list_by_user(current_user_id))}
  end
end
