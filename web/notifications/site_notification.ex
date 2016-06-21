defmodule Webmonitor.SiteNotification do
  import Bamboo.Email

  def down(user, monitor, error) when not is_nil(user) and not is_nil(monitor) do
    new_email(
      from: Webmonitor.Config.for(:default_sender),
      to: user.email,
      subject: "Monitor is DOWN '#{monitor.url}' '#{error}'",
      text_body: "Monitor is DOWN '#{monitor.url}' '#{error}'",
      html_body: "Monitor is DOWN '#{monitor.url}' '#{error}'",
    )
    #mail |> Webmonitor.Mailer.deliver_later
  end

end
