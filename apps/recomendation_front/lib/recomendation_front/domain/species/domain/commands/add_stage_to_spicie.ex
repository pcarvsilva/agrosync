defmodule RecomendationFront.Spicies.Domain.Commands.AddStageToSpicies do
  use Commanded.DDD.Command

  alias RecomendationFront.Spicies.Domain.Entities.Stage

  command do
    [
      uuid: :binary_id,
      stage: Stage
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :stage])
  end
end
