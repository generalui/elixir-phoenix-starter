defmodule EPSWeb.Swagger.Info do
  @moduledoc """
  The outline of the swagger document.
  """

  require EPS.Enums

  def swagger_info do
    app_version = Mix.Project.config()[:version]
    scheme = if System.get_env("RELEASE"), do: "https", else: "http"

    %{
      schemes: [scheme],
      info: %{
        version: app_version,
        title: "Elixir / Phoenix Starter API",
        description: "Documentation for the Elixir / Phoenix Starter API",
        termsOfService: "https://www.example.com/terms-and-conditions"
      },
      securityDefinitions: %{
        Bearer: %{
          type: "apiKey",
          name: "Authorization",
          description: "A valid JWT must be provided via `Authorization: Bearer` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/vnd.api+json"],
      tags: [
        %{
          name: "Version",
          description:
            "The version of the app, the most recent version of the API, and the status of the server."
        }
      ]
    }
  end
end
