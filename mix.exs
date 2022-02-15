defmodule EPS.MixProject do
  use Mix.Project

  @version "0.0.0"

  def project do
    [
      app: :eps,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coverage.html": :test,
        coverage: :test,
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        test: :test,
        tests: :test
      ],
      version: @version,
      elixir: "1.11.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      releases: [
        eps: [
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EPS.Application, []},
      extra_applications: [
        :crypto,
        :logger,
        :prometheus_ex,
        :public_key,
        :runtime_tools,
        :ssl,
        :timex
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # securely hashing & verifying passwords
      {:argon2_elixir, "~> 2.4"},
      {:blankable, "~> 1.0"},
      {:cors_plug, "~> 2.0"},
      {:ecto_boot_migration, "~> 0.3.0"},
      {:ecto_enum, "~> 1.4"},
      {:ecto_sql, "~> 3.6"},
      {:email_checker, "~> 0.1.4"},
      {:ex_doc, "~> 0.24.2"},
      {:ex_json_schema, "~> 0.7.4"},
      {:ex_machina, "~> 2.7"},
      {:faker, "~> 0.16.0"},
      {:gettext, "~> 0.18.2"},
      {:hackney, "~> 1.18"},
      {:httpoison, "~> 1.8"},
      {:inflex, "~> 2.1"},
      {:ja_serializer, "~> 0.16.0"},
      {:jason, "~> 1.2"},
      {:mime, "~> 2.0"},
      {:oauth2, "~> 2.0", override: true},
      {:paginator, "~> 1.0"},
      {:phoenix, "~> 1.5.8"},
      {:phoenix_ecto, "~> 4.2"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:phoenix_swagger, "~> 0.8.3"},
      {:plug_cowboy, "~> 2.4"},
      {:postgrex, ">= 0.15.8"},
      {:prometheus_ex, "~> 3.0"},
      {:prometheus_plugs, "~> 1.1"},
      {:recase, "~> 0.7"},
      {:telemetry_metrics, "~> 0.6.0"},
      {:telemetry_poller, "~> 0.5.1"},
      {:timex, "~> 3.7"},
      {:ex_phone_number, "~> 0.2"},
      {:sweet_xml, "~> 0.7", override: true},

      # development and or test
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:credo_envvar, "~> 0.1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.14.0", only: :test},
      {:expat, "~> 1.0.5", only: :test},
      {:git_hooks, "~> 0.5.2", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:mock, "~> 0.3.0", only: :test},
      {:version_tasks, "~> 0.12.0", only: :dev}
    ]
  end

  defp docs do
    [
      canonical: "/docs",
      javascript_config_path: nil,
      extra_section: "Application README",
      extras: ["README.md", "NOTES.md"],
      formatters: ["html"],
      homepage_url: homepage_url(Mix.env()),
      logo: "priv/static/images/genui-logo.png",
      main: "readme",
      name: "Elixir / Pjhoenix Starter API",
      output: "priv/static/docs",
      source_url: "https://github.com/generalui/elixir-phoenix-starter"
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "coverage.html": &run_coverage/1,
      coverage: &run_coverage/1,
      # Note: Using `mix dev` will start the server, but iex will not function correctly as it is running inside of mix.
      dev: ["cmd iex -S mix phx.server"],
      "ecto.reset": ["ecto.drop --repo EPS.Repo", "ecto.setup"],
      "ecto.setup": [
        "ecto.create --repo EPS.Repo",
        "ecto.migrate --repo EPS.Repo",
        "run priv/repo/seeds.exs"
      ],
      major: "version.up major",
      minor: "version.up minor",
      patch: "version.up patch",
      setup: ["deps.get", "ecto.setup"],
      swagger: ["phx.swagger.generate"],
      tests: &run_tests/1
    ]
  end

  # Ensures tests are run with the correct MIX_ENV environment variable set. See https://spin.atomicobject.com/2018/10/22/elixir-test-multiple-environments/
  defp coverage_with_env(args, env \\ :test) do
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]

    IO.puts(
      "==> " <> IO.ANSI.green() <> "Running coverage with `MIX_ENV=#{env}`" <> IO.ANSI.reset()
    )

    Mix.env(env)

    {_, res} =
      System.cmd("mix", ["ecto.reset" | args],
        arg0: "--quiet",
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end

    {_, res} =
      System.cmd("mix", ["coveralls.html" | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp run_coverage(args) do
    args |> coverage_with_env()
  end

  defp run_tests(args) do
    args |> test_with_env()
  end

  # Ensures tests are run with the correct MIX_ENV environment variable set. See https://spin.atomicobject.com/2018/10/22/elixir-test-multiple-environments/
  defp test_with_env(args, env \\ :test) do
    args = if IO.ANSI.enabled?(), do: ["--color" | args], else: ["--no-color" | args]
    IO.puts("==> " <> IO.ANSI.green() <> "Running tests with `MIX_ENV=#{env}`" <> IO.ANSI.reset())

    Mix.env(env)

    {_, res} =
      System.cmd("mix", ["ecto.reset" | args],
        arg0: "--quiet",
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end

    {_, res} =
      System.cmd("mix", ["test" | args],
        into: IO.binstream(:stdio, :line),
        env: [{"MIX_ENV", to_string(env)}]
      )

    if res > 0 do
      System.at_exit(fn _ -> exit({:shutdown, 1}) end)
    end
  end

  defp homepage_url(:dev) do
    if System.get_env("RELEASE") do
      "https://api.dev.eps-infra.net"
    else
      "http://localhost:" <> (System.get_env("PORT") || "4000")
    end
  end

  defp homepage_url(:staging), do: "https://api.stage.eps-infra.net"
  defp homepage_url(:prod), do: "https://api.prod.eps-infra.net"
  defp homepage_url(:test), do: homepage_url(:dev)
end
