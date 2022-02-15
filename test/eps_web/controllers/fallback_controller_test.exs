defmodule EPSWeb.FallbackControllerTest do
  @moduledoc """
  Tests for the fallback controller.
  """

  use EPSWeb.ConnCase, async: true
  use EPS.Constants.ErrorMessages

  alias EPSWeb.FallbackController

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "call" do
    test "renders 404 not found", %{conn: conn} do
      conn1 = conn |> FallbackController.call({:error, :not_found})

      assert %{
               "errors" => [
                 %{"status" => 404, "title" => @page_not_found}
               ],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn1, 404)

      conn2 = conn |> FallbackController.call(nil)

      assert %{
               "errors" => [
                 %{"status" => 404, "title" => @page_not_found}
               ],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn2, 404)
    end

    test "renders 422 unprocessable entity with list of errors", %{conn: conn} do
      conn1 = conn |> FallbackController.call({:error, ["Something went wrong"]})

      assert %{
               "errors" => [
                 %{"status" => 422, "title" => ["Something went wrong"]}
               ],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn1, 422)
    end

    test "renders 422 unprocessable entity with a single error", %{conn: conn} do
      conn1 = conn |> FallbackController.call({:error, "Something went wrong"})

      assert %{
               "errors" => [
                 %{"status" => 422, "title" => "Something went wrong"}
               ],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn1, 422)
    end

    test "renders 500 server error", %{conn: conn} do
      conn1 = conn |> FallbackController.call(%{"something" => "broken"})

      assert %{
               "errors" => [
                 %{"status" => 500, "title" => @internal_server_error}
               ],
               "jsonapi" => %{"version" => "1.0"}
             } == json_response(conn1, 500)
    end
  end
end
