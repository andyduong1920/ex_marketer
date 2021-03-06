defmodule ExMarketerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExMarketerWeb, :controller
      use ExMarketerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ExMarketerWeb

      import Plug.Conn
      import ExMarketerWeb.Gettext
      import Phoenix.LiveView.Controller

      alias ExMarketerWeb.Router.Helpers, as: Routes

      plug :assign_controller_action_name

      def assign_controller_action_name(conn, _) do
        conn
        |> assign(:controller, controller_module(conn))
        |> assign(:action, action_name(conn))
      end

      def render_404(conn) do
        conn
        |> put_status(:not_found)
        |> put_view(ExMarketerWeb.ErrorView)
        |> render(:"404")
      end

      defp keyword_displayable?(conn, keyword) do
        current_user = conn.assigns.current_user

        !is_nil(keyword) &&
          ExMarketer.Keyword.completed?(keyword) &&
          keyword.user_id === current_user.id
      end
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/ex_marketer_web/templates",
        namespace: ExMarketerWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      import Phoenix.LiveView.Helpers

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ExMarketerWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ExMarketerWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ExMarketerWeb.ErrorHelpers
      import ExMarketerWeb.Gettext
      alias ExMarketerWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
