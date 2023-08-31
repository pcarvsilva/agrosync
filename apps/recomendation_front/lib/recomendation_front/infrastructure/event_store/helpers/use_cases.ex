defmodule Commanded.DDD.UseCase do
  defmacro __using__(_) do
    quote do
      import Commanded.DDD.UseCase
      use Ecto.Schema
    end
  end

  defmacro use_case(do: expression) do
    quote do
      embedded_schema do
        unquote(expression)
      end

      def new(params \\ %{}) do
        Ecto.Changeset.cast(%__MODULE__{}, params, __MODULE__.__schema__(:fields))
        |> handle_validate()
        |> Map.put(:action, :validate)
      end
    end
  end
end
