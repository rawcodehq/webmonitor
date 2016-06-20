defmodule Webmonitor.SigninAction do
  use Webmonitor.Web, :action

  def perform(conn, user) do
    conn
    |> put_session(:user_id, user.id)
  end

end

