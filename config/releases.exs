import Config

# These environment variables MUST be captured in the release config for them to be available in the deployed app. The Environment variables will NOT be available yet during the environment build (config/{dev, staging, prod}.ex).

admin_users = System.get_env("ADMIN_USERS") || "[]"

application_port = String.to_integer(System.get_env("PORT") || "4000")

database_url =
  System.get_env("DATABASE_URL") || raise("Environment variable for DATABASE_URL not set!")

encryption_keys =
  System.get_env("ENCRYPTION_KEYS") || raise("Environment variable for ENCRYPTION_KEYS not set!")

guardian_secret =
  System.get_env("GUARDIAN_SECRET") || raise("Environment variable for GUARDIAN_SECRET not set!")

old_admin_users = System.get_env("ADMIN_USERS_OLD") || admin_users

secret_key_base =
  System.get_env("SECRET_KEY_BASE") || raise("environment variable SECRET_KEY_BASE is missing.")

website_host =
  System.get_env("WEBSITE_HOST") || raise("environment variable WEBSITE_HOST is missing.")

# Configurations the app itself
config :eps,
  admin_users: admin_users,
  base_url: "https://#{website_host}",
  database_url: database_url,
  env: System.get_env("MIX_ENV") |> String.to_atom(),
  encryption_keys: encryption_keys,
  old_admin_users: old_admin_users,
  scheme: "https",
  website_host: website_host

config :eps, EPSWeb.Endpoint,
  http: [port: application_port, transport_options: [socket_opts: [:inet6]]],
  live_reload: [],
  live_view: [signing_salt: secret_key_base],
  reloadable_compilers: [],
  secret_key_base: secret_key_base,
  server: true,
  url: [host: website_host, port: 443]

# Configure the legacy database
config :eps, EPS.Repo, pool_size: String.to_integer(System.get_env("MAX_POOL") || "10")

config :phoenix, :stacktrace_depth, 8

# In release, write the tzdata to a read and writeable dir. See https://hexdocs.pm/tzdata/readme.html#data-directory-and-releases
config :tzdata, :data_dir, "/data"
