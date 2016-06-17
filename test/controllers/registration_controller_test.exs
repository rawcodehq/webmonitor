defmodule Webmonitor.RegistrationControllerTest do
  use Webmonitor.ConnCase

  test "GET /registration/new", %{conn: conn} do
    conn = get conn, "/registration/new"
    assert html_response(conn, 200) =~ "Sign Up"
  end

  @valid_attrs %{email: "mujju@email.com", password: "zainu"}
  test "registration creates user and redirects when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"
    assert Repo.get_by(User, email: @valid_attrs.email)
  end

  test "registration fails if email already exists", %{conn: conn} do
    Repo.insert!(%User{email: @valid_attrs.email})
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    assert html_response(conn, :ok) =~ "Please check the errors below"
  end

end
