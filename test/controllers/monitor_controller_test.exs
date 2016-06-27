defmodule Webmonitor.MonitorControllerTest do
  use Webmonitor.ConnCase

  setup do
    {user, conn} = sign_in(build_conn())
    {:ok, conn: conn, user: user}
  end

  alias Webmonitor.Monitor
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, monitor_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing monitors"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, monitor_path(conn, :new)
    assert html_response(conn, 200) =~ "New monitor"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, monitor_path(conn, :create), monitor: valid_attrs(user)
    assert redirected_to(conn) == monitor_path(conn, :index)
    monitor = Repo.get_by(Monitor, valid_attrs(user))
    assert monitor.user_id == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, monitor_path(conn, :create), monitor: @invalid_attrs
    assert html_response(conn, 200) =~ "New monitor"
  end

  test "shows chosen resource", %{conn: conn} do
    monitor = Repo.insert! %Monitor{}
    conn = get conn, monitor_path(conn, :show, monitor)
    assert html_response(conn, 200) =~ "Show monitor"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, monitor_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    monitor = Repo.insert! %Monitor{}
    conn = get conn, monitor_path(conn, :edit, monitor)
    assert html_response(conn, 200) =~ "Edit monitor"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    monitor = Repo.insert! %Monitor{}
    conn = put conn, monitor_path(conn, :update, monitor), monitor: valid_attrs(user)
    assert redirected_to(conn) == monitor_path(conn, :show, monitor)
    assert Repo.get_by(Monitor, valid_attrs(user))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    monitor = Repo.insert! %Monitor{}
    conn = put conn, monitor_path(conn, :update, monitor), monitor: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit monitor"
  end

  test "deletes chosen resource", %{conn: conn} do
    monitor = Repo.insert! %Monitor{}
    conn = delete conn, monitor_path(conn, :delete, monitor)
    assert redirected_to(conn) == monitor_path(conn, :index)
    refute Repo.get(Monitor, monitor.id)
  end

  def valid_attrs(user) do
    %{name: "some content", url: "http://example.com/awesome", user_id: user.id}
  end
end
