defmodule Webmonitor.PageController do
  use Webmonitor.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
