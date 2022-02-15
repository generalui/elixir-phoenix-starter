defmodule EPS.Repo do
  @moduledoc """
  Repo connects to the DB.
  Get rid of this when the DB is gone / not used.
  """

  use Ecto.Repo,
    otp_app: :eps,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, Application.fetch_env!(:eps, :database_url))}
  end

  def paginate(queryable, opts \\ [], repo_opts \\ []) do
    defaults = [
      limit: 1000,
      maximum_limit: 100_000,
      include_total_count: true,
      total_count_limit: :infinity
    ]

    opts = defaults |> Keyword.merge(opts)
    queryable |> Paginator.paginate(opts, __MODULE__, repo_opts)
  end
end
