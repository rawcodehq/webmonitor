defmodule Webmonitor.UpdateMonitorStatusAction do
  use Webmonitor.Web, :action

  def update(monitor, status) do
    change(monitor, status: status)
    |> Repo.update
  end
end
