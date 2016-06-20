defmodule Webmonitor.MonitorController do
  use Webmonitor.Web, :controller

  alias Webmonitor.Monitor

  plug :scrub_params, "monitor" when action in [:create, :update]

  def index(conn, _params) do
    monitors = conn.assigns.current_user |> unwrap |> Repo.preload(:monitors) |> Map.get(:monitors)
    render(conn, "index.html", monitors: monitors)
  end

  def new(conn, _params) do
    changeset = Monitor.changeset(%Monitor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"monitor" => monitor_params}) do
    {:just, current_user} = conn.assigns.current_user
    monitor_params = Map.put_new(monitor_params, "user_id", current_user.id)
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

  def show(conn, %{"id" => id}) do
    monitor = Repo.get!(Monitor, id)
    render(conn, "show.html", monitor: monitor)
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
end
