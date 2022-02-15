defmodule EPSWeb.DocsController do
  @moduledoc """
  Static documentation controller
  """

  use EPSWeb, :controller

  @content_types %{
    ".css" => "text/css",
    ".eot" => "font/eot",
    ".ico" => "image/x-icon",
    ".jpg" => "image/jpeg",
    ".js" => "text/javascript",
    ".png" => "image/png",
    ".svg" => "image/svg+xml",
    ".ttf" => "font/ttf",
    ".woff" => "font/woff"
  }

  def index(%{path_info: path_info} = conn, _params) when path_info == ["docs"] do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, Application.app_dir(:eps, "priv/static/docs/index.html"))
  end

  def index(%{path_info: path_info} = conn, _params) do
    resource = path_info |> List.last()

    {content_type, path} =
      cond do
        Enum.member?(path_info, "assets") -> {get_content_type(resource), "assets/"}
        Enum.member?(path_info, "fonts") -> {get_content_type(resource), "dist/html/fonts/"}
        Enum.member?(path_info, "dist") -> {get_content_type(resource), "dist/"}
        true -> {"text/html; charset=utf-8", ""}
      end

    conn
    |> put_resp_header("content-type", content_type)
    |> send_file(200, Application.app_dir(:eps, "priv/static/docs/#{path}#{resource}"))
  end

  ### PRIVATE ###

  defp get_content_type(resource) do
    extension = resource |> Path.extname()
    @content_types |> Map.get(extension)
  end
end
