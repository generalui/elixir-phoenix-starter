defmodule EPSWeb.Plugs.NoProdTest do
  @moduledoc """
  Tests for the NoProd plug.
  """

  use EPS.Constants.ErrorMessages
  use EPSWeb.ConnCase, async: false

  alias EPSWeb.Plugs.NoProd

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "init" do
    test "passes the options through" do
      options = %{options: "values"}
      assert options == NoProd.init(options)
    end
  end

  describe "call" do
    test "passes the conn through if not in prod", %{conn: conn} do
      # Build a connection and run the plug
      conn = conn |> NoProd.call(%{})

      assert conn.status != 404
    end

    test "sends to 404 if in prod", %{conn: conn} do
      initial_env = current_env()
      Application.put_env(:eps, :env, :prod)
      # Build a connection and run the plug
      conn = conn |> NoProd.call(%{})

      Application.put_env(:eps, :env, initial_env)

      assert %{
               "errors" => [%{"status" => 404, "title" => @page_not_found}],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn, 404)
    end
  end
end
