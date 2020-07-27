defmodule ExMarketerWeb.SessionController do
  use ExMarketerWeb, :controller

  def new(conn, _) do
    render(conn, :new, changeset: conn, action: "/login")
  end
end
