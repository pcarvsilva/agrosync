defmodule RecomendationFront.Territories.Domain.Entities.Territory do
  use Ecto.Schema

  embedded_schema do
    field(:uuid, :binary_id)
    field(:name, :string)
    field(:image, :string)
    field(:owner_id, :integer)
  end

  alias __MODULE__

  alias RecomendationFront.Territories.Domain.Commands.{
    AddTaskToTerritory,
    AddHistoryToTerritory,
    CreateTerritory
  }

  alias RecomendationFront.Territories.Domain.Events.{
    TaskAddedToTerritory,
    TerritoryCreated,
    HistoryAddedToTerritory
  }

  def execute(%Territory{uuid: nil}, %CreateTerritory{} = command) do
    %TerritoryCreated{
      uuid: command.uuid,
      name: command.name,
      image: command.image,
      owner_id: command.owner_id
    }
  end

  def execute(%Territory{}, %CreateTerritory{}), do: {:error, :already_registered}

  def execute(%Territory{uuid: nil}, %AddTaskToTerritory{}), do: {:error, :territory_not_found}

  def execute(%Territory{}, %AddTaskToTerritory{} = command) do
    %TaskAddedToTerritory{
      uuid: command.uuid,
      description: command.description,
      date: command.date
    }
  end

  def execute(%Territory{uuid: nil}, %AddHistoryToTerritory{}),
    do: {:error, :territory_not_found}

  def execute(%Territory{} = t, %AddHistoryToTerritory{} = command) do
    %HistoryAddedToTerritory{
      uuid: command.uuid,
      description: command.description,
      owner_id: t.owner_id
    }
  end

  def apply(_, %TerritoryCreated{} = evt) do
    %Territory{
      uuid: evt.uuid,
      name: evt.name,
      image: evt.image,
      owner_id: evt.owner_id
    }
  end

  def apply(territory, _), do: territory
end
