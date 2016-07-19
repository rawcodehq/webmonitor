alias Webmonitor.{User, Monitor, MonitorEvent, MonitorStat}
alias Webmonitor.MonitorCheck
alias Webmonitor.Repo
import Ecto.Query

# don't run the monitor checker in the iex console
Application.put_env(:webmonitor, :check_frequency_ms, 1000 * 60_000, persistent: true)
