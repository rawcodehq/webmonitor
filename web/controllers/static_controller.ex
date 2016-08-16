defmodule Webmonitor.StaticController do
  use Webmonitor.Web, :controller
  plug :put_layout, "public.html"

  # NOTE: Add entry to Webmonitor.StaticPages to add a page

  def action(conn, _) do
    apply(__MODULE__, :show, [conn,
      conn.params,
      action_name(conn)])
  end

  def show(conn, _params, template) do
    render conn, template
  end

end
