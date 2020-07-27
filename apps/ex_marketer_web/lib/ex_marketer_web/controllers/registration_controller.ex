defmodule ExMarketerWeb.RegistrationController do
  use ExMarketerWeb, :controller

  plug Ueberauth

  alias ExMarketer.Accounts

  def new(conn, _) do
    render(conn, :new,
      changeset: Accounts.new_account(),
      action: Routes.registration_path(conn, :create)
    )
  end

  def create(%{assigns: %{ueberauth_auth: auth_params}} = conn, _params) do
    case Accounts.register(auth_params) do
      {:ok, account} ->
        redirect(conn, to: Routes.keyword_path(conn, :index))

      {:error, changeset} ->
        render(conn, :new,
          changeset: changeset,
          action: Routes.registration_path(conn, :create)
        )
    end
  end
end
