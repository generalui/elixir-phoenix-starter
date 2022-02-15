defmodule EPSWeb.ErrorView do
  use EPSWeb, :view
  use JaSerializer.PhoenixView
  use EPS.Constants.ErrorMessages

  alias JaSerializer.ErrorSerializer

  def render("400.json-api", _assigns) do
    %{title: @bad_request, status: 400} |> ErrorSerializer.format()
  end

  def render("401.json-api", %{error: _} = assigns) do
    401 |> with_code_and_detail(assigns)
  end

  def render("401.json-api", _assigns) do
    %{title: :unauthorized, status: 401} |> ErrorSerializer.format()
  end

  def render("403.json-api", %{error: _} = assigns) do
    403 |> with_code_and_detail(assigns)
  end

  def render("403.json-api", _assigns) do
    %{title: @forbidden, status: 403} |> ErrorSerializer.format()
  end

  def render("404.json-api", _assigns) do
    %{title: @page_not_found, status: 404} |> ErrorSerializer.format()
  end

  def render("422.json-api", %{error: error} = _assigns) do
    %{title: error, status: 422} |> ErrorSerializer.format()
  end

  def render("422.json-api", _assigns) do
    %{title: @unprocessable_entity, status: 422} |> ErrorSerializer.format()
  end

  def render("500.json-api", _assigns) do
    %{title: @internal_server_error, status: 500} |> ErrorSerializer.format()
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(template, assigns) do
    template
    |> case do
      "400.json" -> render("400.json-api", assigns)
      "401.json" -> render("401.json-api", assigns)
      "403.json" -> render("403.json-api", assigns)
      "404.json" -> render("404.json-api", assigns)
      "422.json" -> render("422.json-api", assigns)
      _ -> render("500.json-api", assigns)
    end
  end

  ### PRIVATE ###

  defp with_code_and_detail(status, %{error: error} = assigns) do
    code = assigns |> Map.get(:code)
    detail = assigns |> Map.get(:detail)
    error_map = %{title: error, status: status}
    error_map = if code, do: error_map |> Map.merge(%{code: code}), else: error_map
    error_map = if detail, do: error_map |> Map.merge(%{detail: detail}), else: error_map
    error_map |> ErrorSerializer.format()
  end
end
