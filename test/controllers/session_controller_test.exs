defmodule Webmonitor.SesssionControllerTest do
  use Webmonitor.ConnCase

  test "GET /session/new", %{conn: conn} do
    conn = get conn, "/session/new"
    assert html_response(conn, 200) =~ "Sign In"
  end

  @valid_attrs %{"email" => "mujju@email.com", "password" => "zainu"}
  test "login sets up the session data properly", %{conn: conn} do
    {:ok, user} = Webmonitor.RegisterUserAction.perform(@valid_attrs)

    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"
    conn = get conn, "/"
    assert html_response(conn, 200) =~ user.email
  end

  test "login fails if email is invalid", %{conn: conn} do
    {:ok, user} = Webmonitor.RegisterUserAction.perform(@valid_attrs)

    conn = post conn, session_path(conn, :create), user: %{email: "ooh@rigby.com", password: user.password}
    assert html_response(conn, 200) =~ "Email or password incorrect"
  end

  test "login fails if password is invalid", %{conn: conn} do
    {:ok, user} = Webmonitor.RegisterUserAction.perform(@valid_attrs)

    conn = post conn, session_path(conn, :create), user: %{email: user.email, password: "please"}
    assert html_response(conn, 200) =~ "Email or password incorrect"
  end

end
