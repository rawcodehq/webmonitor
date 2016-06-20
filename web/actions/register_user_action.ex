defmodule Webmonitor.RegisterUserAction do
  use Webmonitor.Web, :action

  def perform(params) do
    # create the user
    user = User.changeset(%User{}, params)
    case Repo.insert(user) do
      {:ok, user} ->
        {:ok, user}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

end
