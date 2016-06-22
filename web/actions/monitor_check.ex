defmodule Webmonitor.MonitorCheck do
  @moduledoc """
  Checks the monitor and sends an email if there is a problem
  """

  alias Webmonitor.{Repo,SiteNotification,Monitor,Mailer,Checker}

  def check_all do
    monitors =  Repo.all(Monitor)
    for monitor <- monitors do
      spawn fn-> check(monitor) end
    end
  end

  defp check(monitor) do
    case Checker.ping(monitor.url) do
      {:ok, stats} ->
        IO.inspect [monitor, stats]
        # send a message if monitor was previously DOWN
        if Monitor.status_changed?(monitor, :up) do
          send_up_notification(monitor)
        end
      {:error, reason} ->
        if Monitor.status_changed?(monitor, :down) do
          # send a message if monitor was previously UP
          send_down_notification(monitor, reason)
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
