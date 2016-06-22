defmodule Webmonitor.MonitorCheckTest do
  use Webmonitor.ModelCase, async: false
  alias Webmonitor.{SiteNotification,Monitor,MonitorCheck}
  use Bamboo.Test, shared: true

  setup do
    user_attrs = %{"email" => "mujju@email.com", "password" => "zainu"}
    {:ok, user} = Webmonitor.RegisterUserAction.perform(user_attrs)
    {:ok, user: user}
  end

  test "send notification if monitor is down", %{user: user} do
    monitor = Repo.insert! %Monitor{url: "networkwillfail.mujju", user_id: user.id, status: 1}

    mail = SiteNotification.down(user, monitor, ":nxdomain")
    MonitorCheck.check_all
    assert_delivered_email mail
  end

  test "don't send notification if monitor is down and previous state was down", %{user: user} do
    monitor = Repo.insert! %Monitor{url: "networkwillfail.mujju", user_id: user.id, status: 2}

    mail = SiteNotification.down(user, monitor, ":nxdomain")
    MonitorCheck.check_all
    refute_delivered_email mail
  end


  test "send notification if monitor is up", %{user: user} do
    monitor = Repo.insert! %Monitor{url: "http://example.com/", user_id: user.id, status: 2}

    mail = SiteNotification.up(user, monitor)
    MonitorCheck.check_all
    :timer.sleep(1000) # TODO: fix this brittle test
    assert_delivered_email mail
  end

  test "don't send notification if monitor is up", %{user: user} do
    monitor = Repo.insert! %Monitor{url: "http://example.com/", user_id: user.id, status: 1}

    mail = SiteNotification.up(user, monitor)
    MonitorCheck.check_all
    :timer.sleep(1000) # TODO: fix this brittle test
    refute_delivered_email mail
  end

end
