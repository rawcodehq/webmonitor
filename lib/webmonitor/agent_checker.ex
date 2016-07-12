defmodule Webmonitor.AgentChecker do
  require Logger

  @agents Application.get_env(:webmonitor, :agents)
  def check(url) do
    agent = random_agent
    Logger.debug("CHECKING '#{url}' using '#{agent}'")
    case HTTPoison.get(agent_url(agent, url))  do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_response_json(body)
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
      oops ->
        {:error, "Unknown error #{inspect(oops)}"}
    end
  end

  defp parse_response_json(body) do
    case body |> Poison.decode do
      {:ok, response} ->
        parse_response(response)
      {:error, error} ->
        Logger.error("ERROR: while decoding json '#{body}', #{inspect(error)}")
    end
  end

  defp parse_response(%{"status" => "up", "stats" => stats}), do: {:ok, stats}
  defp parse_response(%{"status" => "down", "error" => error}), do: {:down, error}
  defp parse_response(%{"status" => "unknown", "error" => error}), do: {:unknown, error}
  defp parse_response(oops) do
    Logger.error("UNEXPECTED RESPONSE: #{inspect(oops)}")
  end

  defp random_agent do
    Enum.random(@agents)
  end

  defp agent_url(agent, url) do
    URI.encode("#{agent}/monitor?url=#{url}")
  end
end
