defmodule Webmonitor.MonitorCheck do
  @moduledoc """
  Checks the monitor and sends an email if there is a problem
  """

  require Logger
  alias Webmonitor.{Repo,SiteNotification,Monitor,Mailer,Checker, MonitorStat, AgentChecker}

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
      {:ok, stats} -> handle_up(monitor, stats)
      {:our_network_is_down, response} -> Logger.error("OUR_NETWORK_IS_DOWN #{inspect(response)}")
      {:error, reason} ->
        Logger.debug("Monitor #{monitor.id} is down with error: #{inspect(reason)}, performing agent check")
        perform_agent_check(monitor)
    end
  end

  # this is triggered only when the monitor is down
  # TODO: what happens if our agent is also down?
  # we'd get false positives because of the :unknown
  defp perform_agent_check(monitor) do
    case AgentChecker.check(monitor.url) do
      {:up, stats} -> handle_up(monitor, stats)
      {:down, reason} -> handle_down(monitor, reason)
      {:error, response} ->
        Logger.error("ERROR #{inspect(response)}")
        # TODO: should we make the monitor down?
      oops ->
        # TODO: should we make the monitor down?
        Logger.error("UNHANDLED MESSAGE #{inspect(oops)}")
    end
  end

  defp handle_down(monitor, reason) do
    Logger.debug("monitor #{monitor.id} is down")
    if monitor.status != :down || Repo.Monitors.first_event?(monitor) do
      # send a message if monitor was previously UP
      send_down_notification(monitor, reason)
      Webmonitor.UpdateMonitorStatusAction.update(monitor, :down, reason)
    end
  end

  defp handle_up(monitor, stats) do
    Logger.debug("monitor #{monitor.id} is up, response time is #{stats.response_time_ms}ms")
    # send a message if monitor was previously DOWN
    if monitor.status != :up || Repo.Monitors.first_event?(monitor) do
      send_up_notification(monitor)
      Webmonitor.UpdateMonitorStatusAction.update(monitor, :up)
    end
    Repo.insert %MonitorStat{response_time_ms: stats.response_time_ms, monitor_id: monitor.id}
  end

  defp send_up_notification(monitor) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.up(monitor.user, monitor) |> Mailer.deliver_now
  end

  defp send_down_notification(monitor, reason) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.down(monitor.user, monitor, inspect(reason))
    |> Mailer.deliver_now
  end

end
