defmodule EPSWeb.TestCoverageController do
  @moduledoc """
  Static test coverage controller
  """

  use EPSWeb, :controller

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, Application.app_dir(:eps, "priv/static/cover/excoveralls.html"))
  end
end
