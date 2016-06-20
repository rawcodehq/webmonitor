defmodule Webmonitor.MaybeWrapper do
  def wrap(nil), do: :nothing
  def wrap(val), do: {:just, val}

  def unwrap({:just, val}), do: val
  def unwrap(:nothing), do: nil
end
