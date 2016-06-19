defmodule Webmonitor.Repo do
  use Ecto.Repo, otp_app: :webmonitor

  defmodule Users do
    alias Webmonitor.{Repo,User}

    def find_by_email(email) when is_binary(email) do
      Repo.get_by User, email: (email |> String.downcase |> String.strip)
    end
  end
end
