defmodule Webmonitor.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import Webmonitor.ConnCase

      alias Webmonitor.Repo
      alias Webmonitor.{User}
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import Webmonitor.Router.Helpers

      # The default endpoint for testing
      @endpoint Webmonitor.Endpoint

      # TODO: find a better place for this
      def sign_in(conn) do
        user_attrs = %{"email" => "mujju@email.com", "password" => "zainu"}
        {:ok, user} = Webmonitor.RegisterUserAction.perform(user_attrs)

        {user, post(conn, "/session", user: user_attrs)}
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Webmonitor.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Webmonitor.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
