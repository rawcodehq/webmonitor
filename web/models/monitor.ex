defmodule Webmonitor.Monitor do
  use Webmonitor.Web, :model

  # status enum
  defmodule MonitorStatus do
    use Webmonitor.EctoEnum, up: 1, down: 2
  end

  schema "monitors" do
    field :name, :string
    field :url, :string
    field :status, MonitorStatus
    belongs_to :user, Webmonitor.User
    has_many :events, MonitorEvent

    timestamps
  end

  @url_regex ~r/https?:\/\/.*\..*/i
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:url, :name, :user_id])
    |> validate_required([:url, :user_id])
    |> validate_format(:url, @url_regex)
    |> clean_url
  end
  #Ecto.Changeset.validate_format()

  defp clean_url(%Ecto.Changeset{} = cs) do
    case get_change(cs, :url) do
      nil -> cs
      url -> put_change(cs, :url, url |> clean_url)
    end
  end

  defp clean_url(url) do
    uri = URI.parse(url)
    %URI{uri | host: ((uri.host || "") |> String.downcase)} |> URI.to_string
  end

end

