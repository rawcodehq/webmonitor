defmodule Webmonitor.RegistrationController do
  use Webmonitor.Web, :controller

  plug :scrub_params, "user" when action in [:create]

  def new(conn, _params) do
    conn
    |> render(user: User.changeset(%User{}))
  end

  def create(conn, %{"user" => registration_params}) do
    case Webmonitor.RegisterUserAction.perform(registration_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Registered successfully")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please check the errors below")
        |> render(:new, user: changeset)
    end
  end
end
