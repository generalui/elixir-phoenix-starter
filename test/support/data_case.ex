defmodule EPS.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use EPS.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import EPS.DataCase
      import EPS.Constants.General
      import EPS.DataFactory
      import EPS.TestData

      # Ensure Logger is available in tests.
      require Logger

      alias EPS.{Repo, TestLegacyModel, TestModel, TestUtils}
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EPS.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EPS.Repo, {:shared, self()})
    end

    if tags[:legacy] do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(EPS.LegacyRepo)

      unless tags[:async] do
        Ecto.Adapters.SQL.Sandbox.mode(EPS.LegacyRepo, {:shared, self()})
      end
    end

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
