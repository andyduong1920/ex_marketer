defmodule ExMarketerWeb.KeywordLive do
  use ExMarketerWeb, :live_view

  def render(assigns) do
    ~L"""
    Current temperature: <%= @temperature %>
    """
  end

  def mount(_params, _, socket) do
    {:ok, assign(socket, :temperature, 10)}
  end
end
