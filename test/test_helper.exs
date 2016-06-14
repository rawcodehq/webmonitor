ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Webmonitor.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Webmonitor.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Webmonitor.Repo)

