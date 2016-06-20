defmodule Webmonitor.SignoutAction do
  use Webmonitor.Web, :action

  def perform(conn) do
    conn
    |> clear_session
  end

end

