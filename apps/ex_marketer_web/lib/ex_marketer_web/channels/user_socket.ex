defmodule ExMarketerWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "room:*", ExMarketerWeb.RoomChannel
  channel "user:*", ExMarketerWeb.UserChannel

  @max_age 24 * 60 * 60

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :current_user_id, user_id)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def connect(_params, _socket, _connect_info), do: :error

  @impl true
  def id(_socket), do: nil
end
