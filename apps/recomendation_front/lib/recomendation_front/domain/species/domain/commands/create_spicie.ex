defmodule RecomendationFront.Spicies.Domain.Commands.CreateSpicie do
  use Commanded.DDD.Command

  command do
    [
      uuid: :binary_id,
      variety: :string,
      name: :string,
      cultivation_days: :integer
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :variety, :name, :cultivation_days])
    |> validate_number(:cultivation_days, greater_than: 0)
    |> validate_length(:variety, min: 4)
    |> validate_length(:name, min: 4)
  end
end
