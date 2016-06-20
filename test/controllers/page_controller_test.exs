defmodule Webmonitor.PageControllerTest do
  use Webmonitor.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "webmonitor"
  end
end
