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
        #|> Guardian.fl sign the user into our app here
        |> put_session(:user_id, user.id) #TODO: extract into a module
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
    |> clear_session
    |> put_flash(:info, "Successfully logged out")
    |> redirect(to: "/")
  end
end
