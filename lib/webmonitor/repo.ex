defmodule Webmonitor.Repo do
  use Ecto.Repo, otp_app: :webmonitor
  alias Webmonitor.{Repo,User,Monitor}
  require Ecto.Query
  import Ecto.Query, only: [from: 2]

  defmodule Users do
    def find_by_email(email) when is_binary(email) do
      Repo.get_by User, email: (email |> String.downcase |> String.strip)
    end
  end

  defmodule Monitors do

    def for_user(%User{id: id}), do: for_user(id)
    def for_user(user_id) do
      query = from m in Monitor, where: m.user_id == ^user_id
      Repo.all(query)
    end

    def get(user_id, id) do
      query = from m in Monitor, where: m.id == ^id and m.user_id == ^user_id
      Repo.one(query)
    end
  end
end
