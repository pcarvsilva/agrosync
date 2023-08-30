defmodule RecomendationFront.Territories.Domain.Commands.CreateTerritory do
  use Commanded.DDD.Command

  command do
    [
      uuid: :binary_id,
      name: :string,
      image: :string,
      owner_id: :integer
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :name, :owner_id])
    |> validate_length(:name, min: 4, max: 35)
  end
end
