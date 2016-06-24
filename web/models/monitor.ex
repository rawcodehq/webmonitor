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

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:url, :name, :user_id])
    |> validate_required([:url, :user_id])
  end

  # TODO: add an enum custom type
  def status_changed?(monitor, new_status) do
    @statuses[new_status] != monitor.status
  end

end

