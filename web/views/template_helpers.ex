defmodule Webmonitor.TemplateHelpers do

  def monitor_label(monitor) do
    if monitor.name do
      "#{monitor.name} [#{monitor.url}]"
    else
      monitor.url
    end
  end

  def t_time(_conn, nil), do: ""
  def t_time(conn, %Ecto.DateTime{} = datetime) do
    user = conn.assigns.current_user |> Webmonitor.MaybeWrapper.unwrap
    tz = Timex.Timezone.get(user.timezone)
    datetime |> Ecto.DateTime.to_erl |> Timex.DateTime.from_erl |> Timex.Timezone.convert(tz)
  end
  def t_time(_conn, datetime), do: "Invalid arg #{inspect(datetime)}"

  @strftime "%Y-%m-%d %I:%M%P"
  #@strftime "%Y-%m-%d %I:%M:%S %p %:z"
  def format_datetime(%Timex.DateTime{} = datetime) do
    {:ok, s} = Timex.format(datetime, @strftime, :strftime)
    s
  end
  def format_datetime(conn, %Ecto.DateTime{} = datetime) do
    t_time(conn, datetime) |> format_datetime
  end

  def user_signed_in?(conn), do: conn.assigns.current_user != :nothing

  # helper methods
  def safe_get(nil, _key), do: nil
  def safe_get(:nothing, _key), do: nil
  def safe_get({:just, val}, key), do: safe_get(val, key)
  def safe_get(%{} = map, [key|rest]), do: safe_get(Map.get(map, key), rest)
  def safe_get(val, []), do: val
  def safe_get(%{} = map, key), do: safe_get(map, [key])
end
