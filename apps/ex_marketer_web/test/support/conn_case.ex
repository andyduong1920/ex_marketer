defmodule ExMarketerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExMarketerWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExMarketerWeb.ConnCase
      import ExMarketerWeb.Factory
      import ExMarketerWeb.Gettext

      alias ExMarketerWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ExMarketerWeb.Endpoint

      @doc """
      Setup helper that registers and logs in users.

          setup :register_and_log_in_user

      It stores an updated connection and a registered user in the
      test context.
      """
      def register_and_log_in_user(%{conn: conn}) do
        user = insert(:user)
        %{conn: log_in_user(conn, user), user: user}
      end

      @doc """
      Logs the given `user` into the `conn`.

      It returns an updated `conn`.
      """
      def log_in_user(conn, user) do
        token = ExMarketer.Accounts.generate_user_session_token(user)

        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> Plug.Conn.put_session(:user_token, token)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ExMarketer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ExMarketer.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
