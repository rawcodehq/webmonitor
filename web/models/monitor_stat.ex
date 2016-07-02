defmodule Webmonitor.MonitorStat do
  use Webmonitor.Web, :model

  schema "monitor_stats" do
    field :response_time_ms, :integer
    belongs_to :monitor, Webmonitor.Monitor

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:response_time_ms])
    |> validate_required([:response_time_ms])
  end
end
