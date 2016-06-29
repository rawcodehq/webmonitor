defmodule Webmonitor.UpdateMonitorStatusAction do
  use Webmonitor.Web, :action

  def update(monitor, status, reason \\ nil) do
    # update the monitor
    change(monitor, status: status)
    |> Repo.update
    # create an event
    Repo.insert(%Webmonitor.MonitorEvent{monitor_id: monitor.id, status: status, reason: format_reason(reason)})
  end

  defp format_reason(nil), do: "OK"
  defp format_reason(str) when is_binary(str), do: str
  defp format_reason(reason), do: inspect(reason)
end
