defmodule RecomendationFront.Spicies.Domain.Events.StageAddedToSpicie do
  alias RecomendationFront.Spicies.Domain.Entities.Stage
  use Ecto.Schema

  @derive Jason.Encoder
  embedded_schema do
    field(:uuid, :binary_id)
    field(:stage, Stage)
  end
end
