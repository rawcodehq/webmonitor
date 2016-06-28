defmodule Webmonitor.MonitorEventTest do
  use Webmonitor.ModelCase

  alias Webmonitor.MonitorEvent

  @valid_attrs %{status: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MonitorEvent.changeset(%MonitorEvent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MonitorEvent.changeset(%MonitorEvent{}, @invalid_attrs)
    refute changeset.valid?
  end
end
