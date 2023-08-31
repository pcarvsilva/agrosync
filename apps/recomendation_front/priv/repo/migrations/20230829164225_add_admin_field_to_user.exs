defmodule RecomendationFront.Repo.Migrations.AddAdminFieldToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:admin, :bool)
    end
  end
end
