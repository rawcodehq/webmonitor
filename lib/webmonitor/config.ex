defmodule Webmonitor.Config do
  @moduledoc """
  Use to access our custom config data
  """

  def for(key, default \\ nil), do: Application.get_env(:webmonitor, key, default)
end
