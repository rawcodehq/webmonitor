defmodule Webmonitor.User do
  use Webmonitor.Web, :model

  schema "users" do
    field :email, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> encrypt_password
    |> clean_email
    |> unique_constraint(:email)
  end

  def password_valid?(nil, _password), do: Comeonin.Bcrypt.dummy_checkpw
  def password_valid?(user, password), do: Comeonin.Bcrypt.checkpw(password, user.encrypted_password)

  # encrypt password only if the password field has a change
  defp encrypt_password(%Ecto.Changeset{} = cs) do
    case get_change(cs, :password) do
      nil -> cs
      password ->
        encrypted_password =  Comeonin.Bcrypt.hashpwsalt(password)
        put_change(cs, :encrypted_password, encrypted_password)
    end
  end

  defp clean_email(cs) do
    case get_change(cs, :email) do
      nil -> cs
      email -> put_change(cs, :email, email|> String.downcase)
    end
  end
end
