defmodule Webmonitor.MonitorEvent do
  use Webmonitor.Web, :model

  schema "monitor_events" do
    field :status, Webmonitor.Monitor.MonitorStatus
    field :reason, :string
    belongs_to :monitor, Webmonitor.Monitor

    timestamps(updated_at: false)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
  end
end
