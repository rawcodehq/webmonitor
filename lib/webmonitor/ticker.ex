defmodule Webmonitor.Ticker do
  use GenServer
  require Logger
  alias Webmonitor.MonitorCheck

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

  defp do_work(_state) do
    # trigger a run
    Logger.info("triggering MonitorCheck.check_all")
    spawn(&MonitorCheck.check_all/0)
  end

  defp schedule_work do
    Process.send_after(self(), :work, Application.get_env(:webmonitor, :check_frequency_ms))
  end
end
