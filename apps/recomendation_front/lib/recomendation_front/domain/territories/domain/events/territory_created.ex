defmodule RecomendationFront.Territories.Domain.Events.TerritoryCreated do
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:name, :string)
    field(:image, :string)
    field(:owner_id, :integer)
  end
end
