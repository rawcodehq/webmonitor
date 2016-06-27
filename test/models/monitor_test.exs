defmodule Webmonitor.MonitorTest do
  use Webmonitor.ModelCase

  alias Webmonitor.Monitor

  @valid_attrs %{name: "some content", url: "http://example.com", user_id: 3}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Monitor.changeset(%Monitor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Monitor.changeset(%Monitor{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid url should be invalid" do
    changeset = Monitor.changeset(%Monitor{}, %{name: "some content", url: "some content", user_id: 3})
    refute changeset.valid?
  end

  test "cleans up the url scheme" do
    changeset = Monitor.changeset(%Monitor{}, %{name: "some content", url: "HTTP://google.com", user_id: 3})
    assert changeset.changes.url == "http://google.com"
  end

  test "cleans up the host" do
    changeset = Monitor.changeset(%Monitor{}, %{name: "some content", url: "HTTP://GOOgle.com", user_id: 3})
    assert changeset.changes.url == "http://google.com"
  end

  test "does not change the path" do
    changeset = Monitor.changeset(%Monitor{}, %{name: "some content", url: "HTTP://GOOgle.com/FooBar.aspX", user_id: 3})
    assert changeset.changes.url == "http://google.com/FooBar.aspX"
  end
end
