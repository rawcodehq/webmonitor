defmodule Webmonitor.UserController do
  use Webmonitor.Web, :controller

  def edit(conn, _params) do
    user = User.changeset(conn.assigns.current_user|> unwrap)
    conn
    |> render(user: user)
  end

  def update(conn, %{"user" => %{"timezone" => timezone}}) do
    Webmonitor.UpdateUserTimezoneAction.update (conn.assigns.current_user |> unwrap), timezone
    conn
    |> put_flash(:info, "Successfully updated the user")
    |> redirect(to: "/user/edit")
  end

end
