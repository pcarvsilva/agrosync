defmodule RecomendationFront.Spicies.Domain.Entities.Stage do
  @behaviour Ecto.Type

  def type, do: :string

  @valid_types [:colonizer, :pioneer, :initial_secondary, :late_secondary, :climax]

  @valid_strings Enum.reduce(@valid_types, [], fn t, acc -> [Atom.to_string(t) | acc] end)
  @valid_map Enum.reduce(@valid_types, %{}, fn t, acc -> Map.put(acc, Atom.to_string(t), t) end)

  @valid_inverse_map Enum.reduce(@valid_types, %{}, fn t, acc ->
                       Map.put(acc, t, Atom.to_string(t))
                     end)

  @type t() :: unquote(Enum.reduce(Enum.reverse(@valid_types), &{:|, [], [&1, &2]}))

  def load(data), do: cast(data)

  def valid_types, do: @valid_types

  def cast(data) when is_atom(data) and data in @valid_types, do: {:ok, data}
  def cast(data) when is_binary(data) and data in @valid_strings, do: {:ok, @valid_map[data]}
  def cast(_), do: :error

  def dump(data) when is_atom(data) and data in @valid_types, do: {:ok, @valid_inverse_map[data]}
  def dump(data) when is_binary(data) and data in @valid_strings, do: {:ok, data}
  def dump(_), do: :error

  def embed_as(_), do: :dump
  def equal?(data, data), do: true

  def equal?(data_1, data_2) do
    case {cast(data_1), cast(data_2)} do
      {{:ok, same}, {:ok, same}} -> true
      _ -> false
    end
  end
end
