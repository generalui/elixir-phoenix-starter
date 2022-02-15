defmodule EPSWeb.VersionView do
  use EPSWeb, :view

  def render("index.json", %{app_version: app_version, version: version}) do
    %{
      releaseId: app_version,
      status: 200,
      version: version
    }
  end
end
