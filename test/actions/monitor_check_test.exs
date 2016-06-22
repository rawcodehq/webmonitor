defmodule Webmonitor.MonitorCheckTest do
  use Webmonitor.ModelCase
  alias Webmonitor.{SiteNotification,Monitor,MonitorCheck}
  use Bamboo.Test, shared: true

  test "send notification if monitor is down" do
    #TODO: move this to a helper function
    user_attrs = %{"email" => "mujju@email.com", "password" => "zainu"}
    {:ok, user} = Webmonitor.RegisterUserAction.perform(user_attrs)
    monitor = Repo.insert! %Monitor{url: "networkwillfail.mujju", user_id: user.id, status: 1}

    mail = SiteNotification.down(user, monitor, ":nxdomain")
    MonitorCheck.check_all
    assert_delivered_email mail
  end

  test "send notification if monitor is up" do
    #TODO: move this to a helper function
    user_attrs = %{"email" => "mujjux@email.com", "password" => "zainu"}
    {:ok, user} = Webmonitor.RegisterUserAction.perform(user_attrs)
    monitor = Repo.insert! %Monitor{url: "http://google.com", user_id: user.id, status: 2}

    mail = SiteNotification.up(user, monitor)
    MonitorCheck.check_all
    #assert_delivered_email mail
  end
end
