defmodule Webmonitor.CheckerTest do
  use Webmonitor.ModelCase
  import Webmonitor.Checker

  alias Webmonitor.Checker.Stats

  test "ping returns :ok when website is up" do
    assert {:ok, %Stats{}} = ping("http://httpstat.us/200")
  end

  test "ping returns :error when website returns a redirect" do
    assert {:error, _} = ping("http://httpstat.us/302")
  end

  test "ping returns :error when website returns a 40x code" do
    assert {:error, _} = ping("http://httpstat.us/404")
  end

  test "ping returns :error when website returns a 50x code" do
    assert {:error, _} = ping("http://httpstat.us/501")
  end

  test "ping returns :error when dns doesn't resolve" do
    assert {:error, _} = ping("http://abracadabra.mujju.and.zainu")
  end

end
