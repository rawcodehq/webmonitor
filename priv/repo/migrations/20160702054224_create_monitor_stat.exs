defmodule Webmonitor.Repo.Migrations.CreateMonitorStat do
  use Ecto.Migration

  def change do
    create table(:monitor_stats) do
      add :response_time_ms, :integer
      add :monitor_id, references(:monitors, on_delete: :delete_all), null: false

      add :inserted_at, :datetime
    end
    create index(:monitor_stats, [:monitor_id])
  end
end
