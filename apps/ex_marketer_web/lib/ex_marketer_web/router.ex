defmodule ExMarketerWeb.Router do
  use ExMarketerWeb, :router

  import ExMarketerWeb.Accounts.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
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
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: ExMarketerWeb.Telemetry)
    end
  end

  ## Authentication routes

  scope "/", ExMarketerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/register", Accounts.UserRegistrationController, :new
    post "/register", Accounts.UserRegistrationController, :create
    get "/login", Accounts.UserSessionController, :new
    post "/login", Accounts.UserSessionController, :create
    get "/reset_password", Accounts.UserResetPasswordController, :new
    post "/reset_password", Accounts.UserResetPasswordController, :create
    get "/reset_password/:token", Accounts.UserResetPasswordController, :edit
    put "/reset_password/:token", Accounts.UserResetPasswordController, :update
  end

  scope "/", ExMarketerWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/settings", Accounts.UserSettingsController, :edit
    put "/settings/update_password", Accounts.UserSettingsController, :update_password
    put "/settings/update_email", Accounts.UserSettingsController, :update_email
    get "/settings/confirm_email/:token", Accounts.UserSettingsController, :confirm_email

    resources("/keywords", KeywordController, only: [:show, :index, :new, :create])
    resources("/pages", PageController, only: [:show])
  end

  scope "/", ExMarketerWeb do
    pipe_through [:browser]

    get("/", HomeController, :index)

    delete "/log_out", Accounts.UserSessionController, :delete
    get "/confirm", Accounts.UserConfirmationController, :new
    post "/confirm", Accounts.UserConfirmationController, :create
    get "/confirm/:token", Accounts.UserConfirmationController, :confirm
  end
end
