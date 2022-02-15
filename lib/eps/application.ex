defmodule EPS.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Run any migrations that haven't been run in the release environments.
    # {:ok, _} = EctoBootMigration.migrate(:eps)
    # Start the Prometheus exporter.
    EPS.Telemetry.MetricsSetup.setup()

    children = [
      # Start the Ecto repository
      # EPS.Repo,
      # Start the Telemetry supervisor
      EPS.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EPS.PubSub},
      # Start the Endpoint (http/https)
      EPSWeb.Endpoint
      # Start a worker by calling: EPS.Worker.start_link(arg)
      # {EPS.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EPS.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EPSWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
