defmodule EPSWeb.Plugs.NoProd do
  @moduledoc """
  Plug that redirects to 404 if in prod
  """

  use EPSWeb, :controller

  alias EPS.Constants.General

  def init(options), do: options

  def call(conn, _options) do
    if General.current_env() == :prod do
      conn
      |> put_status(404)
      |> put_view(EPSWeb.ErrorView)
      |> render("404.json-api", [])
      |> halt()
    else
      conn
    end
  end
end
