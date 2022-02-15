defmodule EPSWeb.VersionControllerTest do
  @moduledoc """
  Tests for the version controller.
  """

  use EPSWeb.ConnCase, async: true

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "show version", %{conn: conn} do
      app_version = Application.spec(:eps, :vsn) |> List.to_string()
      conn = get(conn, Routes.version_path(conn, :index))

      assert json_response(conn, 200) == %{
               "releaseId" => app_version,
               "status" => 200,
               "version" => "v1"
             }
    end
  end
end
