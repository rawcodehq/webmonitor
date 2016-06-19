defmodule Webmonitor.ModelHelpers do
  defmacro __using__(_) do
    quote do
      def empty_changeset do
        __MODULE__.changeset(__MODULE__.__struct__)
      end
    end
  end
end
