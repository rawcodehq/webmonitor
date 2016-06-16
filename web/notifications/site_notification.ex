defmodule Webmonitor.SiteNotification do
  import Bamboo.Email

  def down(user, site, error) do
    new_email(
      from: Webmonitor.Config.for(:default_sender),
      to: user.email,
      subject: "Site is DOWN '#{site.url}' '#{error}'",
      text_body: "Site is DOWN '#{site.url}' '#{error}'",
      html_body: "Site is DOWN '#{site.url}' '#{error}'",
    )
    #mail |> Webmonitor.Mailer.deliver_later
  end
end
