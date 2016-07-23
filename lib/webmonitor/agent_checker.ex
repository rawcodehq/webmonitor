defmodule Webmonitor.AgentChecker do
  require Logger

  alias Webmonitor.Checker.Stats

  # accepts a url and returns one of the following
  # {:up, %{} = stats}
  # {:down, reason}
  # {:error, error}
  def check(url) do
    Logger.debug("CHECKING '#{url}'")
    case invoke_lambda(url) do
      {:ok, %{"errorMessage" => error}} ->
        Logger.debug("LAMBDA ERROR: #{inspect(error)}")
        {:error, inspect(error)}
      {:ok, response} ->
        parse_response(response)
      {:error, error} -> # error in making the API call
        Logger.debug("API/NETWORK ERROR: #{inspect(error)}")
        {:error, inspect(error)}
    end
  end

  # TODO: test the following
  # connection error
  # SSL error
  # incorrect status code
  # dns error
  defp parse_response(%{"status" => 200, "response_time_ms" => response_time_ms}), do: {:up, %Stats{response_time_ms: response_time_ms}}
  defp parse_response(%{"status" => status_code, "response_time_ms" => _response_time_ms}) when is_number(status_code), do: {:down, "#{status_code} response"}
  defp parse_response(%{"status" => "down", "response_time_ms" => _response_time_ms, "message" => message}) do
    Logger.debug(message)
    {:down, message}
  end
  defp parse_response(%{"status" => "error", "error" => error}), do: {:error, error}
  defp parse_response(oops) do
    Logger.error("UNEXPECTED RESPONSE: #{inspect(oops)}")
    {:error, "unexpected response"}
  end

  defp invoke_lambda(url) do
    # function_name, payload, context, options
    ExAws.Lambda.invoke("check_url", %{url: url} , %{}, [invocation_type: "RequestResponse", log_type: "Tail"]) |> ExAws.request
  end
end
