defmodule Webmonitor.UserTest do
  use Webmonitor.ModelCase

  alias Webmonitor.User

  @valid_attrs %{email: "some content", password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email is cleaned up before saving" do
    changeset = User.changeset(%User{}, %{email: "\t\n muJJU@zainU.COM    \t\n", password: "some content"})
    assert changeset.changes.email ==  "mujju@zainu.com"
  end

end
