defmodule Webmonitor.PageController do
  use Webmonitor.Web, :controller

  def index(%{assigns: %{current_user: :nothing}} = conn, params) do
    render conn, "index.html"
  end

  def index(conn, params) do
    put_in(conn.private.phoenix_view, Webmonitor.MonitorView)
    |> Webmonitor.MonitorController.index(params)
  end
end
