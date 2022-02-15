defmodule EPSWeb.ChangesetView do
  use EPSWeb, :view

  require Logger

  alias JaSerializer.EctoErrorSerializer

  def render("error.json-api", %{changeset: changeset, status: status}) do
    Logger.error("Error status #{status}: #{inspect(changeset)}\n", ansi_color: :red)
    changeset |> EctoErrorSerializer.format(opts: [status: status])
  end
end
