defmodule Webmonitor.Monitor do
  use Webmonitor.Web, :model

  @statuses %{up: 1, down: 2}

  schema "monitors" do
    field :name, :string
    field :url, :string
    field :status, :integer # default value 1. 1 => :up, 2 => :down
    belongs_to :user, Webmonitor.User

    timestamps
  end

  @required_fields ~w(url)
  @optional_fields ~w(name user_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end

