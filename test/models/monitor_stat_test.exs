defmodule Webmonitor.MonitorStatTest do
  use Webmonitor.ModelCase

  alias Webmonitor.MonitorStat

  @valid_attrs %{response_time_ms: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = MonitorStat.changeset(%MonitorStat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = MonitorStat.changeset(%MonitorStat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
