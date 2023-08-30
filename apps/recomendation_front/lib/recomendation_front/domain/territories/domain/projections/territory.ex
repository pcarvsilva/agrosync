defmodule RecomendationFront.Territories.Domain.Projections.Territory do
  use Ecto.Schema
  alias RecomendationFront.Accounts.User

  schema "territory" do
    field(:uuid, :binary_id)
    field(:name, :string)
    field(:image, :string)

    belongs_to(:owner, User)

    timestamps()
  end
end
