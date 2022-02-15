defmodule EPS.Telemetry.MetricsSetup do
  @moduledoc """
  Auth controller responsible for handling Ueberauth responses
  """

  alias EPSWeb.Metrics.Exporter

  def setup do
    Exporter.setup()
  end
end
