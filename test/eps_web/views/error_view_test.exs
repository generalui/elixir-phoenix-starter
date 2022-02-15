defmodule EPSWeb.ErrorViewTest do
  @moduledoc """
  Tests for the error view.
  """

  use EPSWeb.ConnCase, async: true
  use EPS.Constants.ErrorMessages

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json-api" do
    assert render(EPSWeb.ErrorView, "400.json", []) == %{
             "errors" => [%{status: 400, title: @bad_request}],
             "jsonapi" => %{"version" => "1.0"}
           }

    assert render(EPSWeb.ErrorView, "400.json-api", []) == %{
             "errors" => [%{status: 400, title: @bad_request}],
             "jsonapi" => %{"version" => "1.0"}
           }
  end

  test "renders 401.json-api" do
    assert render(EPSWeb.ErrorView, "401.json", []) == %{
             "errors" => [%{status: 401, title: :unauthorized}],
             "jsonapi" => %{"version" => "1.0"}
           }

    assert render(EPSWeb.ErrorView, "401.json-api", []) == %{
             "errors" => [%{status: 401, title: :unauthorized}],
             "jsonapi" => %{"version" => "1.0"}
           }
  end

  test "renders 403.json-api" do
    assert render(EPSWeb.ErrorView, "403.json", []) == %{
             "errors" => [%{status: 403, title: @forbidden}],
             "jsonapi" => %{"version" => "1.0"}
           }

    assert render(EPSWeb.ErrorView, "403.json-api", []) == %{
             "errors" => [%{status: 403, title: @forbidden}],
             "jsonapi" => %{"version" => "1.0"}
           }
  end

  test "renders 404.json-api" do
    assert render(EPSWeb.ErrorView, "404.json", []) == %{
             "errors" => [%{status: 404, title: @page_not_found}],
             "jsonapi" => %{"version" => "1.0"}
           }

    assert render(EPSWeb.ErrorView, "404.json-api", []) == %{
             "errors" => [%{status: 404, title: @page_not_found}],
             "jsonapi" => %{"version" => "1.0"}
           }
  end

  test "renders 422.json-api" do
    assert render(EPSWeb.ErrorView, "422.json", []) == %{
             "errors" => [%{status: 422, title: @unprocessable_entity}],
             "jsonapi" => %{"version" => "1.0"}
           }

    assert render(EPSWeb.ErrorView, "422.json-api", []) == %{
             "errors" => [%{status: 422, title: @unprocessable_entity}],
             "jsonapi" => %{"version" => "1.0"}
           }
  end

  test "renders 500.json" do
    assert render(EPSWeb.ErrorView, "500.json", []) ==
             %{
               "errors" => [%{status: 500, title: @internal_server_error}],
               "jsonapi" => %{"version" => "1.0"}
             }

    assert render(EPSWeb.ErrorView, "500.json-api", []) ==
             %{
               "errors" => [%{status: 500, title: @internal_server_error}],
               "jsonapi" => %{"version" => "1.0"}
             }
  end
end
