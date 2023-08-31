defmodule RecomendationFront.Territories.Domain.Commands.AddHistoryToTerritory do
  use Commanded.DDD.Command

  command do
    [
      uuid: :binary_id,
      description: :string
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :description])
    |> validate_length(:description, min: 4, max: 35)
  end
end
