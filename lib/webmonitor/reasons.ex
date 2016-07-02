defmodule Webmonitor.Reasons do
  @reasons %{
    :nxdomain => "Hostname or domain name cannot be found"
  }

  def reason_for(error) do
    Map.get(@reasons, error, error)
  end
end
