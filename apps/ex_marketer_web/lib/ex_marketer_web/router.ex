defmodule ExMarketerWeb.Router do
  use ExMarketerWeb, :router

  import ExMarketerWeb.Accounts.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:fetch_live_flash)
    plug :put_root_layout, {ExMarketerWeb.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
    plug(:put_user_socket_token)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth_layout do
    plug(:put_layout, {ExMarketerWeb.LayoutView, :auth})
  end

  defp put_user_socket_token(conn, _) do
    if current_user = conn.assigns.current_user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_socket_token, token)
    else
      conn
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExMarketerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through(:browser)
    live_dashboard("/dashboard", metrics: ExMarketerWeb.Telemetry, ecto_repos: [ExMarketer.Repo])
  end

  ## Authentication routes

  scope "/", ExMarketerWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated, :auth_layout])

    get("/register", Accounts.UserRegistrationController, :new)
    post("/register", Accounts.UserRegistrationController, :create)
    get("/login", Accounts.UserSessionController, :new)
    post("/login", Accounts.UserSessionController, :create)
    get("/reset_password", Accounts.UserResetPasswordController, :new)
    post("/reset_password", Accounts.UserResetPasswordController, :create)
    get("/reset_password/:token", Accounts.UserResetPasswordController, :edit)
    put("/reset_password/:token", Accounts.UserResetPasswordController, :update)
  end

  scope "/", ExMarketerWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/settings", Accounts.UserSettingsController, :edit)
    put("/settings/update_password", Accounts.UserSettingsController, :update_password)
    put("/settings/update_email", Accounts.UserSettingsController, :update_email)
    get("/settings/confirm_email/:token", Accounts.UserSettingsController, :confirm_email)

    resources("/keywords", KeywordController, only: [:create])
    resources("/pages", PageController, only: [:show])

    live "/keywords", KeywordLive.IndexLive, :index
    live "/keywords/:id", KeywordLive.IndexLive, :show
  end

  scope "/", ExMarketerWeb do
    pipe_through([:browser])

    get("/", HomeController, :index)

    delete("/log_out", Accounts.UserSessionController, :delete)
    get("/confirm", Accounts.UserConfirmationController, :new)
    post("/confirm", Accounts.UserConfirmationController, :create)
    get("/confirm/:token", Accounts.UserConfirmationController, :confirm)
  end
end
