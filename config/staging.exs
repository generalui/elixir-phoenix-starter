use Mix.Config

# Import the prod config. This must remain at the top
# of this file so it overrides the configuration defined for prod.
import_config "prod.exs"

application_port = String.to_integer(System.get_env("PORT") || "4000")

website_host = System.get_env("WEBSITE_HOST") || "api.stage.eps-infra.net"

# Configurations the app itself
config :eps,
  base_url: "https://#{website_host}",
  website_host: website_host

config :eps, EPSWeb.Endpoint, url: [host: website_host, port: application_port]
