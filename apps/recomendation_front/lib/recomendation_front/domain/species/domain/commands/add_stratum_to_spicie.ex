defmodule RecomendationFront.Spicies.Domain.Commands.AddStratumToSpicies do
  use Commanded.DDD.Command

  alias RecomendationFront.Spicies.Domain.Entities.Stratum

  command do
    [
      uuid: :binary_id,
      stratum: Stratum
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :stratum])
  end
end
