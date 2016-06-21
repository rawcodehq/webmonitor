defmodule Webmonitor.MonitorChecker do
  alias Webmonitor.{Repo,Monitor}

  def check_all do
    monitors =  Repo.all(Monitor)
    for monitor <- monitors do
      spawn(&Webmonitor.MonitorCheck.perform/1)
    end
  end

end
