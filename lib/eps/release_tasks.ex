defmodule EPS.ReleaseTasks do
  @moduledoc """
  Any tasks that might normally be run using `mix` (e.g. running DB migrations)
  should be done here.
  """

  import Ecto.Query, warn: false

  @otp_app :eps
  @start_apps [:logger, :ssl, :postgrex, :ecto, :ex_machina, :faker, :timex]

  def migrate(repo) do
    init(@otp_app, @start_apps, repo)
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    stop()
  end

  def rollback(repo, version) do
    init(@otp_app, @start_apps, repo)
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
    stop()
  end

  def seed(repo) do
    init(@otp_app, @start_apps, repo)

    "#{seed_path(@otp_app)}/*.exs"
    |> Path.wildcard()
    |> Enum.sort()
    |> Enum.each(&run_seed_script/1)

    stop()
  end

  ### PRIVATE ###

  defp init(app, start_apps, repo) do
    IO.puts("Loading app..")
    :ok = Application.load(app)

    IO.puts("Starting dependencies..")
    Enum.each(start_apps, &Application.ensure_all_started/1)

    IO.puts("Starting repo..")

    repo.start_link(pool_size: 2)
  end

  defp priv_dir(app, path) when is_list(path) do
    case :code.priv_dir(app) do
      priv_path when is_list(priv_path) or is_binary(priv_path) ->
        Path.join([priv_path] ++ path)

      {:error, :bad_name} ->
        raise ArgumentError, "unknown application: #{inspect(app)}"
    end
  end

  defp run_seed_script(seed_script) do
    IO.puts("Running seed script #{seed_script}..")
    Code.eval_file(seed_script)
  end

  defp seed_path(app), do: priv_dir(app, ["repo"])

  defp stop do
    IO.puts("Success!")
    :init.stop()
  end
end
