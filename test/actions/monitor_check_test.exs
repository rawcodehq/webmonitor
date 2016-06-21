defmodule Webmonitor.MonitorCheckTest do
  use Webmonitor.ModelCase
  alias Webmonitor.{SiteNotification,Monitor,MonitorCheck}
  use Bamboo.Test, shared: true

  test "send notification if monitor is down" do
    #TODO: move this to a helper function
    user_attrs = %{"email" => "mujju@email.com", "password" => "zainu"}
    {:ok, user} = Webmonitor.RegisterUserAction.perform(user_attrs)
    monitor = %Monitor{url: "networkwillfail.mujju", id: 33, user_id: user.id}

    mail = SiteNotification.down(user, monitor, "nxdomain")
    MonitorCheck.perform(monitor)
    assert_delivered_email mail
  end
end
