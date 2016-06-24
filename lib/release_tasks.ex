defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:webmonitor)

    path = Application.app_dir(:webmonitor, "priv/repo/migrations")

    Ecto.Migrator.run(Webmonitor.Repo, path, :up, all: true)

    :init.stop()
  end
end
