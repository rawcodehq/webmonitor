defmodule Webmonitor.Repo.Migrations.RemoveUpdatedAtFromMonitorEvents do
  use Ecto.Migration

  def change do
    alter table(:monitor_events) do
      remove(:updated_at)
    end
  end
end
