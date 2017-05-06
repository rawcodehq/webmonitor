alias Webmonitor.{User, Monitor, MonitorEvent, MonitorStat}
alias Webmonitor.MonitorCheck
alias Webmonitor.Repo
import Ecto.Query

# don't run the monitor checker in the iex console
Application.put_env(:webmonitor, :check_frequency_ms, 1000 * 60_000, persistent: true)


#:dbg.start
#:dbg.tracer
#:dbg.p(:all, :c)

#:dbg.tpl(:gen_smtp, '_')


#alias Webmonitor.{Repo,SiteNotification,Monitor,Mailer,Checker, MonitorStat, AgentChecker}

#send_email = fn ->
 #monitor = Repo.one(Monitor, limit: 1)
   #monitor = Repo.preload(monitor, :user)
   #monitor = put_in(monitor.user.email, "minhajuddink@gmail.com")
   ## send a notification
   #SiteNotification.up(monitor.user, monitor) |> Mailer.deliver_now
#end

#send_email.()

#:dbg.stop_clear
