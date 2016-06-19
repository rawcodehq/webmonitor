defmodule Webmonitor.LayoutView do
  use Webmonitor.Web, :view

  # helper methods
  def safe_get(nil, _key), do: nil
  def safe_get(:nothing, _key), do: nil
  def safe_get({:just, val}, key), do: safe_get(val, key)
  def safe_get(%{} = map, [key|rest]), do: safe_get(Map.get(map, key), rest)
  def safe_get(val, []), do: val
  def safe_get(%{} = map, key), do: safe_get(map, [key])

  def user_signed_in?(conn), do: conn.assigns.current_user != :nothing
end
