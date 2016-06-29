defmodule Webmonitor.UpdateUserTimezoneAction do
  use Webmonitor.Web, :action

  def update(user, timezone) do
    # update the monitor
    change(user, timezone: timezone)
    |> Repo.update
  end
end

