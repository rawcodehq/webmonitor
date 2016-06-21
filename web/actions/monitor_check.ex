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
        # nothing to do at the moment
        IO.inspect [monitor, stats]
      {:error, reason} ->
        send_notification(monitor, reason)
    end
  end

  defp send_notification(monitor, reason) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.down(monitor.user, monitor, inspect(reason))
    |> Mailer.deliver_now
  end

end
