defmodule Webmonitor.Repo.Migrations.AddErrorToMonitorEvents do
  use Ecto.Migration

  def change do
    alter table(:monitor_events) do
      add :reason, :string
    end
  end
end
