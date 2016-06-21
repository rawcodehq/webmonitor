defmodule Webmonitor.MonitorCheck do
  @moduledoc """
  Checks the monitor and sends an email if there is a problem
  """

  alias Webmonitor.{Repo,SiteNotification,Mailer,Checker}

  def perform(monitor) do
    case Checker.ping(monitor.url) do
      #{:ok, _stats} ->
        # nothing to do at the moment
      {:error, reason} ->
        send_notification(monitor, reason)
    end
  end

  defp send_notification(monitor, reason) do
    monitor = Repo.preload(monitor, :user)
    # send a notification
    SiteNotification.down(monitor.user, monitor, to_string(reason))
    |> Mailer.deliver_now
  end

end
