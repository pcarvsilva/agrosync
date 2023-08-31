defmodule RecomendationFront.Spicies.Domain.Projections.Spicie do
  use Ecto.Schema

  alias RecomendationFront.Spicies.Domain.Entities.{Stage, Stratum}

  schema "spicie" do
    field(:uuid, :binary_id)
    field(:variety, :string)
    field(:name, :string)
    field(:cultivation_days, :integer)
    field(:stratum, Stratum)
    field(:stage, Stage)

    timestamps()
  end
end
