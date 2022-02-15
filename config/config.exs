# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Load the environment variables from the appropriate .env file.
env =
  Mix.env()
  |> case do
    :prod -> ""
    env -> "-#{env}"
  end

try do
  # In case .env file does not exist.
  File.stream!("./.env#{env}")
  # Remove excess whitespace
  |> Stream.map(&String.trim_trailing/1)
  # Loop through each line
  |> Enum.each(fn line ->
    line
    # Split on *first* "=" (equals sign)
    |> String.split("=", parts: 2)
    # stackoverflow.com/q/33055834/1148249
    |> Enum.reduce(fn value, key ->
      # Skip all comments
      if key |> String.starts_with?("#") == false do
        # Set each environment variable
        System.put_env(key, value)
      end
    end)
  end)
rescue
  _ ->
    IO.puts(
      IO.ANSI.yellow() <>
        "There was no `.env#{env}` file found. Please ensure the required environment variables have been set." <>
        IO.ANSI.reset()
    )
end

admin_users = System.get_env("ADMIN_USERS") || "[]"

old_admin_users = System.get_env("ADMIN_USERS_OLD") || admin_users

config :eps,
  admin_users: admin_users,
  ecto_repos: [EPS.Repo],
  encryption_keys: System.get_env("ENCRYPTION_KEYS"),
  env: Mix.env(),
  namespace: EPS,
  old_admin_users: old_admin_users

# Configures the endpoint
config :eps, EPSWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/gettext/.*(po)$},
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|json)$},
      ~r{priv/static/cover/excoveralls.html$},
      ~r{priv/static/swagger.json$},
      ~r{lib/eps_web/controllers/.*(ex)$},
      ~r{lib/eps_web/controllers/v4/.*(ex)$},
      ~r{lib/eps_web/plugs/.*(ex)$},
      ~r{lib/eps_web/swagger/.*(ex)$},
      ~r{lib/eps_web/templates/.*(eex)$},
      ~r{lib/eps_web/views/.*(ex)$}
    ]
  ],
  pubsub_server: EPS.PubSub,
  reloadable_compilers: [:gettext, :phoenix, :elixir, :phoenix_swagger],
  render_errors: [view: EPSWeb.ErrorView, accepts: ~w(json json-api), layout: false],
  url: [host: "localhost"]

# Configure Phoenix Swagger
config :eps, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: EPSWeb.Router
    ]
  }

# Ensure Phoenix Swagger uses Jason instead of Poison
config :phoenix_swagger, json_library: Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix, :format_encoders, "json-api": Jason

config :mime, :types, %{"application/vnd.api+json" => ["json-api"]}

config :ja_serializer, key_format: :camel_cased

# Configure the email checker (for email validation).
config :email_checker,
  default_dns: :system,
  also_dns: [],
  validations: [EmailChecker.Check.Format, EmailChecker.Check.MX],
  smtp_retries: 2,
  timeout_milliseconds: 5000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
