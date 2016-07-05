# Algorithm to calculate downtime
#   1. Decide the duration (24 hours, 7 days, 30 days)
#   2. Select all the events in that duration
#   3. Add an UP event at the end of the duration
#   4.
#     i.  Add a inverse of the first event at the beginning of this duration
#         e.g. if the first event is an UP add a DOWN and vice versa
#     ii. If there is no event in the duration, use the status of the latest event before start time
#   5. Start from the first UP event after a DOWN event and subtract the DOWN event_at from the UP event_at, do this till you reach the end.
#       This gives you the downtime
#   6. Subtract duration from downtime to get uptime duration
#     e.g.
#       1. 24 hour duration. Current Time is 00hours
#       2. UPat1 DOWNat5 UPat10
#       3. UPat1 DOWNat5 UPat10 UPat24
#       4. DOWNat0 UPat1 DOWNat5 UPat10 UPat24
#       5. UPat1 - DOWNat0 + UPat10 - DOWNat5
#         Downtime = 1 + 5
#       6. 24 - 6 => 18
# TODO: can we do this in postgresql? That would be faster
defmodule Webmonitor.UptimeCalculator do
  require Ecto.Query
  import Ecto.Query

  alias Webmonitor.{Repo, Monitor, MonitorEvent}

  def uptime(%Monitor{} = monitor, :day) do
    uptime(monitor, days_ago(1), now)
  end
  def uptime(%Monitor{} = monitor, :week) do
    uptime(monitor, days_ago(7), now)
  end
  def uptime(%Monitor{} = monitor, :month) do
    uptime(monitor, days_ago(30), now)
  end

  #@spec uptime(Monitor.t, non_neg_integer)
  def uptime(%Monitor{} = monitor, start_time, end_time) do

    # 1. duration
    duration = duration_for(start_time, end_time)

    # 2. events in duration
    events = events_for(monitor, start_time, end_time)

    # 3. Add UP event at the tail
    events = events ++ [%MonitorEvent{status: :up, inserted_at: end_time}] # NOTE: this is slow, any way to make this faster?

    # 4. Add inverse event at the head
    events = [%MonitorEvent{status: first_event_status(monitor, start_time), inserted_at: start_time} | events]

    downtime = downtime_for(events)
    (100 * (duration - downtime) / duration) |> Float.round(3) # uptime percentage
  end

  # seconds of downtime
  defp downtime_for(events) do
    {_, downtime} = Enum.reduce(events, {:first, 0}, fn(curr, {prev, downtime})->
      # skip the first loop
      # if previous event is a down event, we need to
      # subtract it from the current event which should be up
      if prev != :first && prev.status == :down do
        :up = curr.status # assert that the current event is up
        downtime = downtime + Timex.diff(curr.inserted_at |> to_timex, prev.inserted_at |> to_timex, :seconds)
      end

      {curr, downtime}
    end)
    downtime
  end

  defp events_for(monitor, start_time, end_time) do
    Repo.all(from me in MonitorEvent, where: me.monitor_id == ^monitor.id and me.inserted_at >= ^start_time and me.inserted_at <= ^end_time, order_by: :inserted_at)
  end

  defp duration_for(start_time, end_time) do
    Timex.diff(start_time |> to_timex, end_time |> to_timex, :seconds)
  end

  # if there are no events in our interval, we need to use the status
  # of the latest event before start time
  defp first_event_status(monitor, start_time) do
    event = Repo.one(from me in MonitorEvent,
     where: me.monitor_id == ^monitor.id and me.inserted_at <= ^start_time,
     order_by: [desc: :inserted_at],
     limit: 1)
    case event do
      nil -> :up # this means there are no events for this monitor
      event -> event.status
    end
  end

  defp now, do: Ecto.DateTime.utc
  defp days_ago(days, offset \\ now) do
    {:ok, date} = offset
                  |> Timex.Ecto.DateTime.cast!
                  |> Timex.shift(days: -1 * days)
                  |> Timex.Ecto.DateTime.dump
    date
  end

  defp to_timex(%Ecto.DateTime{} = date), do: Timex.Ecto.DateTime.cast!(date)
  defp to_timex(date), do: Timex.DateTime.from_erl(date)
end
