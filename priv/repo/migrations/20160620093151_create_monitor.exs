defmodule Webmonitor.Repo.Migrations.CreateMonitor do
  use Ecto.Migration

  def change do
    create table(:monitors) do
      add :name, :string
      add :url, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:monitors, [:user_id])

  end
end
