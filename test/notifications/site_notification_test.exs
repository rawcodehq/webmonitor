defmodule Webmonitor.SiteNotificationTest do
  use Webmonitor.ModelCase
  import Webmonitor.SiteNotification
  #use Bamboo.Test

  test "#down sends an email notification" do
    mail = down(%{email: "m@u.jju"}, %{url: "https://cosmicvent.com/"}, "No Connection")
    assert mail.from == "Webmonitor Notification <noreply@webmonitor.com>"
    assert mail.to ==  "m@u.jju"
    assert mail.subject == "Site is DOWN 'https://cosmicvent.com/' 'No Connection'"
    assert mail.text_body == "Site is DOWN 'https://cosmicvent.com/' 'No Connection'"
    assert mail.html_body == "Site is DOWN 'https://cosmicvent.com/' 'No Connection'"
    #assert_delivered_email "x"
  end
end

