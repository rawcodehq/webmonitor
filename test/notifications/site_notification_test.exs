defmodule Webmonitor.SiteNotificationTest do
  use Webmonitor.ModelCase
  import Webmonitor.SiteNotification

  test "#down sends an email notification" do
    mail = down(%{email: "m@u.jju"}, %{url: "https://cosmicvent.com/"}, "No Connection")
    assert mail.from == {"Webmonitor Notification", "noreply@webmonitorhq.com"}
    assert mail.to ==  "m@u.jju"
    assert mail.subject == "Monitor is DOWN 'https://cosmicvent.com/' 'No Connection'"
    assert mail.text_body == "Monitor is DOWN 'https://cosmicvent.com/' 'No Connection'"
    assert mail.html_body == "Monitor is DOWN 'https://cosmicvent.com/' 'No Connection'"
  end

  test "#up sends an email notification" do
    mail = up(%{email: "m@u.jju"}, %{url: "https://cosmicvent.com/"})
    assert mail.from == {"Webmonitor Notification", "noreply@webmonitorhq.com"}
    assert mail.to ==  "m@u.jju"
    assert mail.subject == "Monitor is UP 'https://cosmicvent.com/'"
    assert mail.text_body == "Monitor is UP 'https://cosmicvent.com/'"
    assert mail.html_body == "Monitor is UP 'https://cosmicvent.com/'"
  end
end

