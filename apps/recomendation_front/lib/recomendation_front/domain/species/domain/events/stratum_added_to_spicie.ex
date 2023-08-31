defmodule RecomendationFront.Spicies.Domain.Events.StratumAddedToSpicie do
  alias RecomendationFront.Spicies.Domain.Entities.Stratum
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:stratum, Stratum)
  end
end
