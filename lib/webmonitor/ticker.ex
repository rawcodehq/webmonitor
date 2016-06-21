defmodule Webmonitor.Ticker do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    schedule_work()
    {:ok, []}
  end

  def handle_info(:work, state) do
    state = do_work(state)
    schedule_work()
    {:noreply, state}
  end

  defp do_work(state) do
    # trigger a run
    spawn(&MonitorChecker.check_all/0)
  end

  @interval_in_ms 60_000
  defp schedule_work do
    Process.send_after(self(), :work, @interval_in_ms)
  end
end
