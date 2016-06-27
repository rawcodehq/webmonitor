defmodule Webmonitor.EctoEnum do
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Ecto.Type

      @atom_map opts |> Enum.into(%{})
      @int_map opts |> Enum.map(fn {key, val} -> {val, key} end) |> Enum.into(%{})

      def type, do: :integer

      # when casting is done, out should always be atom
      def cast(int) when is_integer(int), do: {:ok, @int_map[int]}
      def cast(atom) when is_atom(atom),  do: {:ok, @atom_map[atom]}
      def cast(_), do: :error

      # when data is loaded from db, out should always be atom
      def load(int) when is_integer(int), do: {:ok, @int_map[int]}

      # For saving this data into the database, so the result should
      # always be an integer, because that is what the db stores
      def dump(int) when is_integer(int), do: {:ok, int}
      def dump(atom) when is_atom(atom),  do: {:ok, @atom_map[atom]}
      def dump(_), do: :error
    end
  end
end
