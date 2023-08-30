defmodule RecomendationFront.Spicies.Domain.Projections.Spicie do
  use Ecto.Schema

  schema "spicie" do
    field(:uuid, :binary_id)
    field(:variety, :string)
    field(:name, :string)
    field(:cultivation_days, :integer)

    timestamps()
  end
end
