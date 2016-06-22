defmodule Webmonitor.Checker do
  @moduledoc """
  Takes care of checking the health of a website
  """

  require Logger

  defmodule Stats do
    @type t :: %Webmonitor.Checker.Stats{response_time: non_neg_integer}
    defstruct response_time: 0
  end

  @spec ping(binary) :: {atom, binary | Stats.t}
  def ping(url) when is_binary(url) do
    Logger.debug("PINGING #{url}")
    {microseconds, response} = :timer.tc(HTTPoison, :get, [url])
    case response do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %Stats{response_time: round(microseconds/1000)}}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Non successful status code #{status_code}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      oops ->
        {:error, "Unknown error #{inspect(oops)}"}
    end
  end
end
