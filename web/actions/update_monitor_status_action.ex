defmodule Webmonitor.UpdateMonitorStatusAction do
  use Webmonitor.Web, :action

  def update(monitor, status) do
    # update the monitor
    change(monitor, status: status)
    |> Repo.update
    # create an event
    Repo.insert(%Webmonitor.MonitorEvent{monitor_id: monitor.id, status: status})
  end
end
