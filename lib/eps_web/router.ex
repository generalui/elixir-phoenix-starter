defmodule EPSWeb.Router do
  use EPSWeb, :router

  import Phoenix.LiveDashboard.Router

  alias EPSWeb.Swagger.Info

  pipeline :api_deserializer do
    plug JaSerializer.Deserializer
  end

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    plug :fetch_session
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
  end

  pipeline :no_prod do
    plug EPSWeb.Plugs.NoProd
  end

  pipeline :secure do
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :secure_no_csrf do
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/api", EPSWeb, as: :api do
    pipe_through [:api, :api_deserializer]

    scope "/v1", V1, as: :v1 do
    end
  end

  scope "/healthcheck", EPSWeb do
    pipe_through [:api, :api_deserializer]
    get "/", VersionController, :index
  end

  scope "/", EPSWeb do
    pipe_through [:browser, :secure]

    scope "/test_coverage" do
      pipe_through [:no_prod]
      get "/", TestCoverageController, :index
    end
  end

  def swagger_info do
    Info.swagger_info()
  end

  scope "/" do
    scope "/api/swagger" do
      pipe_through [:browser]

      forward "/", PhoenixSwagger.Plug.SwaggerUI,
        otp_app: :eps,
        swagger_file: "swagger.json",
        disable_validator: true
    end

    scope "/dashboard" do
      pipe_through [:browser, :secure]

      live_dashboard "/", metrics: EPS.Telemetry
    end

    scope "/docs", EPSWeb do
      pipe_through [:no_prod, :browser]
      get "/*path", DocsController, :index
    end

    # This catches requests via the documentation
    scope "/", EPSWeb do
      pipe_through [:no_prod, :browser, :secure]
      get "/*path", DocsController, :index
    end
  end
end
