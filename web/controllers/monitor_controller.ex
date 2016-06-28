defmodule Webmonitor.MonitorController do
  use Webmonitor.Web, :controller

  alias Webmonitor.{Monitor,MonitorEvent}

  # TODO: all queries should be anchored by current_user.id

  plug :scrub_params, "monitor" when action in [:create, :update]

  def index(conn, _params) do
    monitors = Repo.Monitors.for_user(current_user_id(conn))
    render(conn, "index.html", monitors: monitors)
  end

  def new(conn, _params) do
    changeset = Monitor.changeset(%Monitor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monitor" => monitor_params}) do
    monitor_params = Map.put_new(monitor_params, "user_id", current_user_id(conn))
    changeset = Monitor.changeset(%Monitor{}, monitor_params)

    case Repo.insert(changeset) do
      {:ok, _monitor} ->
        conn
        |> put_flash(:info, "Monitor created successfully.")
        |> redirect(to: monitor_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def check(conn, %{"id" => id}) do
    monitor = Repo.Monitors.get(current_user_id(conn), id)
    conn
    |> render(monitor: monitor)
  end

  def show(conn, %{"id" => id}) do
    monitor = Repo.get!(Monitor, id)
    # TODO: find a way to get it in this order via monitor.events
    events = Repo.all(from e in MonitorEvent, where: e.monitor_id == ^monitor.id, order_by: [desc: :id])
    render(conn, "show.html", monitor: monitor, events: events)
  end

  def edit(conn, %{"id" => id}) do
    monitor = Repo.get!(Monitor, id)
    changeset = Monitor.changeset(monitor)
    render(conn, "edit.html", monitor: monitor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "monitor" => monitor_params}) do
    monitor = Repo.get!(Monitor, id)
    changeset = Monitor.changeset(monitor, monitor_params)

    case Repo.update(changeset) do
      {:ok, monitor} ->
        conn
        |> put_flash(:info, "Monitor updated successfully.")
        |> redirect(to: monitor_path(conn, :show, monitor))
      {:error, changeset} ->
        render(conn, "edit.html", monitor: monitor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    monitor = Repo.get!(Monitor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(monitor)

    conn
    |> put_flash(:info, "Monitor deleted successfully.")
    |> redirect(to: monitor_path(conn, :index))
  end

  defp current_user_id(conn) do
    (conn.assigns.current_user |> unwrap).id
  end
end
