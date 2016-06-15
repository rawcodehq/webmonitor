defmodule Webmonitor.Checker do
  @moduledoc """
  Takes care of checking the health of a website
  """

  defmodule Stats do
    @type t :: %Webmonitor.Checker.Stats{response_time: non_neg_integer}
    defstruct response_time: 1
  end

  @spec ping(binary) :: {atom, binary | Stats.t}
  def ping(url) when is_binary(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %Stats{}}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Non successful status code #{status_code}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
