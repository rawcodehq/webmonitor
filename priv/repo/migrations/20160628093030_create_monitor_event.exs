defmodule Webmonitor.Repo.Migrations.CreateMonitorEvent do
  use Ecto.Migration

  def change do
    create table(:monitor_events) do
      add :status, :integer, null: false
      add :monitor_id, references(:monitors, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:monitor_events, [:monitor_id])

  end
end
