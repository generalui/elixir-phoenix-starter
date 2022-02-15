defmodule EPSWeb.VersionController do
  use EPSWeb, :controller
  use EPSWeb.Swagger.Version

  action_fallback EPSWeb.FallbackController

  def index(conn, _params) do
    app_version = Application.spec(:eps, :vsn) |> List.to_string()
    conn |> render("index.json", app_version: app_version, version: "v1")
  end
end
