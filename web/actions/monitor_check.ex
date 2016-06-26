defmodule Webmonitor.MonitorCheck do
  @moduledoc """
  Checks the monitor and sends an email if there is a problem
  """

  require Logger
  alias Webmonitor.{Repo,SiteNotification,Monitor,Mailer,Checker}

  def check_all do
    monitors =  Repo.all(Monitor)
    Logger.debug("checking #{Enum.count(monitors)} monitors")
    for monitor <- monitors do
      spawn fn-> check(monitor) end
    end
  end

  def check(monitor) do
    Logger.debug "checking monitor #{monitor.url} [#{monitor.id}]"
    case Checker.ping(monitor.url) do
      {:ok, stats} ->
        Logger.debug("monitor #{monitor.id} is up, response time is #{stats.response_time}ms")
        # send a message if monitor was previously DOWN
        if Monitor.status_changed?(monitor, :up) do
          send_up_notification(monitor)
          Webmonitor.UpdateMonitorStatusAction.update(monitor, 1)
        end
      {:error, reason} ->
        Logger.debug("monitor #{monitor.id} is down")
        if Monitor.status_changed?(monitor, :down) do
          # send a message if monitor was previously UP
          send_down_notification(monitor, reason)
          Webmonitor.UpdateMonitorStatusAction.update(monitor, 2)
        end
    end
  end

  defp send_up_notification(monitor) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.up(monitor.user, monitor)
    |> Mailer.deliver_now
  end

  defp send_down_notification(monitor, reason) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.down(monitor.user, monitor, inspect(reason))
    |> Mailer.deliver_now
  end

end
