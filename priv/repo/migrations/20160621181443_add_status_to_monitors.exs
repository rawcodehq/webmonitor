defmodule Webmonitor.Repo.Migrations.AddStatusToMonitors do
  use Ecto.Migration

  def change do
    alter table(:monitors) do
      add :status, :integer, default: 1
    end
  end
end
