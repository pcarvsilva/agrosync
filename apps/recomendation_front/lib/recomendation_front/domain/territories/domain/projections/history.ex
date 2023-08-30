defmodule RecomendationFront.Territories.Domain.Projections.History do
  use Ecto.Schema
  alias RecomendationFront.Accounts.User
  alias RecomendationFront.Territories.Domain.Projections.Territory

  schema "history" do
    field(:description, :string)
    field(:date, :naive_datetime)

    belongs_to(:territory, Territory,
      type: :binary_id,
      references: :uuid,
      foreign_key: :territory_uuid
    )

    belongs_to(:user, User)

    timestamps()
  end
end
