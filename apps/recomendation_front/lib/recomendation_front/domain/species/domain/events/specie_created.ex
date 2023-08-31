defmodule RecomendationFront.Spicies.Domain.Events.SpiecieCreated do
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:variety, :string)
    field(:name, :string)
    field(:cultivation_days, :integer)
  end
end
