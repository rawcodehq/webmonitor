defmodule Webmonitor.SessionController do
  use Webmonitor.Web, :controller

  def new(conn, _params) do
    conn
    |> render(user: User.empty_changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Webmonitor.AuthenticateUserAction.perform(user_params) do
      {:ok, user} ->
        conn
        |> Webmonitor.SigninAction.perform(user)
        |> put_flash(:info, "Signed in successfully")
        |> redirect(to: "/")
      :error ->
        conn
        |> put_flash(:error, "Email or password incorrect")
        |> render(:new, user: User.changeset(%User{}, %{email: user_params["email"]}))
    end
  end

  def delete(conn, _params) do
    conn
    |> Webmonitor.SignoutAction.perform(conn)
    |> put_flash(:info, "Successfully logged out")
    |> redirect(to: "/")
  end
end
