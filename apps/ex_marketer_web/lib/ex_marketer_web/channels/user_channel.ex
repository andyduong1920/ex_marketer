defmodule ExMarketerWeb.UserChannel do
  use ExMarketerWeb, :channel

  def join("user:" <> id, _params, socket) do
    if String.to_integer(id) === socket.assigns[:current_user_id] do
      {:ok, socket}
    else
      {:error, :unauthorized}
    end
  end

  def handle_info({:keyword_successed, params}, socket) do
    push(socket, "keyword_successed", %{keyword_id: params.keyword_id})

    {:noreply, socket}
  end

  def handle_info({:keyword_fail, params}, socket) do
    push(socket, "keyword_fail", %{keyword_id: params.keyword_id})

    {:noreply, socket}
  end
end
