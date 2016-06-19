defmodule Webmonitor.AuthenticateUserAction do
  use Webmonitor.Web, :action

  def perform(%{"email" => email, "password" => password}) do
    user = Repo.Users.find_by_email(email)
    if User.password_valid?(user, password) do
      {:ok, user}
    else
      :error
    end
  end

end
