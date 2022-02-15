defmodule EPSWeb.JsonRest do
  @moduledoc """
  The JsonRest module provides wrapper functions function HTTPoison.request
  """

  def get_json(url, options) do
    request(:get, url, "", options)
  end

  def post_json(url, options, body) do
    request(:post, url, Jason.encode!(body), options)
  end

  ### PRIVATE ###

  defp request(method, url, body, options) do
    HTTPoison.start()

    case HTTPoison.request(method, url, body, Keyword.get(options, :headers, []), options) do
      {:ok, response} ->
        if trunc(response.status_code / 100) == 2 do
          {:ok, response}
        else
          {:error, response}
        end

      {:error, _} = error ->
        error
    end
  end
end
