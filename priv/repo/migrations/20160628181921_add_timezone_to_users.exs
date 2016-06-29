defmodule Webmonitor.Repo.Migrations.AddTimezoneToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :timezone, :string, default: "UTC", null: false
    end
  end
end
