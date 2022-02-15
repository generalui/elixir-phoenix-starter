defmodule EPSWeb.Swagger.Version do
  @moduledoc """
  Swagger definitions used in the version controller.
  """

  use PhoenixSwagger

  defmacro __using__(_) do
    quote do
      swagger_path :index do
        get("/healthcheck")
        summary("The status and version of the app")
        description("The status and version of the app")
        produces("application/json")
        response(200, "OK", Schema.ref(:HealthCheck))
      end

      def swagger_definitions do
        %{
          HealthCheck:
            swagger_schema do
              title("HealthCheck")
              description("Health Check and application information.")

              properties do
                releaseId(:string, "The current version of the application", required: true)
                status(:string, "The status (health) of the application.", required: true)
                version(:string, "The most recent version of the API", required: true)
              end

              example(%{
                releaseId: Mix.Project.config()[:version],
                status: 200,
                version: "v1"
              })
            end
        }
      end
    end
  end
end
