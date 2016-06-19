defmodule Webmonitor.AuthenticateUser do
  @moduledoc """
  redirects the user to the home page with an error message if user is not logged in
  """
  use Webmonitor.Web, :plug

  def call(conn, _opts) do
    case conn.assigns.current_user do
      :nothing ->
        conn
        |> put_flash(:error, "Please sign in to view this page")
        |> redirect(to: "/")
        |> halt
      _ ->
        conn
    end
  end
end

