defmodule Commanded.DDD.Command do
  defmacro __using__(_) do
    quote do
      import Commanded.DDD.Command
    end
  end

  defmacro command(do: expression) do
    quote do
      use Commanded.Command,
          unquote(expression)
    end
  end
end
