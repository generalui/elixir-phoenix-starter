# Start the ex_machina app (must be started before ExUnit).
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Exclude all external tests from running
ExUnit.configure(exclude: [external: true])

ExUnit.start()
Faker.start()
# Ecto.Adapters.SQL.Sandbox.mode(EPS.Repo, :manual)
Code.compile_file("test/support/test_utils.exs")
