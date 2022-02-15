defmodule EPS.Telemetry do
  @moduledoc """
  Telemetry
  """

  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller will execute the given period measurements
      # every 10_000ms. Learn more here: https://hexdocs.pm/telemetry_metrics
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
      # Add reporters as children of your supervision tree.
      # {Telemetry.Metrics.ConsoleReporter, metrics: metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      ### Phoenix Metrics Start ###
      summary("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      # Phoenix Count Metrics - Formats `count` metric type
      counter("phoenix.router_dispatch.stop.count"),
      counter("phoenix.error_rendered.count"),
      # Phoenix Time Metrics - Formats `timing` metric type
      summary("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),
      ### Phoenix Metrics End ###

      ### Database Metrics Start ###
      # Database Time Metrics - Formats `timing` metric type
      summary("eps.repo.query.total_time", unit: {:native, :millisecond}),
      summary("eps.repo.query.decode_time", unit: {:native, :millisecond}),
      summary("eps.repo.query.query_time", unit: {:native, :millisecond}),
      summary("eps.repo.query.queue_time", unit: {:native, :millisecond}),
      summary("eps.repo.query.idle_time", unit: {:native, :millisecond}),
      # Database Count Metrics - Formats `count` metric type
      counter("eps.repo.query.count", tags: [:source, :command]),
      ### Database Metrics End ###

      ### VM Metrics Start ###
      summary("vm.memory.total", unit: {:byte, :kilobyte}),
      summary("vm.total_run_queue_lengths.total"),
      summary("vm.total_run_queue_lengths.cpu"),
      summary("vm.total_run_queue_lengths.io"),
      last_value("vm.system_counts.process_count")
      ### VM Metrics End ###
    ]
  end

  ### PRIVATE ###

  defp periodic_measurements do
    [
      # A module, function and arguments to be invoked periodically.
      # This function must call :telemetry.execute/3 and a metric must be added above.
      # {EPSWeb, :count_users, []}
    ]
  end
end
