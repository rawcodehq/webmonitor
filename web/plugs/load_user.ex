defmodule Webmonitor.LoadUser do
  use Webmonitor.Web, :plug

  def call(conn, _opts) do
    user = case get_session(conn, :user_id) do
      nil -> :nothing
      user_id -> {:just, Repo.get(User, user_id)}
    end

    assign(conn, :current_user, user)
  end
end
