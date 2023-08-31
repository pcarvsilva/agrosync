defmodule RecomendationFront.Territories.Domain.Events.HistoryAddedToTerritory do
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:description, :string)
    field(:owner_id, :integer)
  end
end
