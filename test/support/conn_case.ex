defmodule EPSWeb.ConnCase do
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
  by setting `use EPSWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  use Plug.Test
  use EPS.Constants.General

  import EPS.DataFactory

  alias EPS.Users
  alias EPS.Users.User
  alias EPSWeb.Auth.Guardian

  using do
    quote do
      # Ensure Logger is available in tests.
      require Logger
      # Use SchemaTest to validate swagger schemas in controllers.
      # use PhoenixSwagger.SchemaTest, "priv/static/swagger.json"
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import EPSWeb.ConnCase
      import EPS.Constants.General
      import EPS.DataFactory
      import EPS.TestData

      alias EPSWeb.Router.Helpers, as: Routes
      alias EPS.TestUtils

      # The default endpoint for testing
      @endpoint EPSWeb.Endpoint
    end
  end

  # setup tags do
  #   :ok = Ecto.Adapters.SQL.Sandbox.checkout(EPS.Repo)

  #   unless tags[:async] do
  #     Ecto.Adapters.SQL.Sandbox.mode(EPS.Repo, {:shared, self()})
  #   end

  #   if tags[:legacy] do
  #     :ok = Ecto.Adapters.SQL.Sandbox.checkout(EPS.LegacyRepo)

  #     unless tags[:async] do
  #       Ecto.Adapters.SQL.Sandbox.mode(EPS.LegacyRepo, {:shared, self()})
  #     end
  #   end

  #   {:ok, conn: Phoenix.ConnTest.build_conn() |> init_test_session(%{})}
  # end
end
