defmodule Webmonitor.MonitorView do
  use Webmonitor.Web, :view

  def monitor_label(monitor) do
    if monitor.name do
      "#{monitor.name} [#{monitor.url}]"
    else
      monitor.url
    end
  end
end
