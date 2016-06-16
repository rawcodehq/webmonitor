defmodule Webmonitor.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Webmonitor.Repo
  alias Webmonitor.User

  # serializing
  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  # deserializing
  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end

