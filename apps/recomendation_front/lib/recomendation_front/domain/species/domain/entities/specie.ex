defmodule RecomendationFront.Spicies.Domain.Entities.Spicie do
  use Ecto.Schema

  embedded_schema do
    field(:uuid, :binary_id)
    field(:variety, :string)
    field(:name, :string)
    field(:cultivation_days, :integer)
  end

  alias __MODULE__

  alias RecomendationFront.Spicies.Domain.Commands.{
    CreateSpicie,
    AddStratumToSpicies,
    AddStageToSpicies
  }

  alias RecomendationFront.Spicies.Domain.Events.{
    SpiecieCreated,
    StageAddedToSpicie,
    StratumAddedToSpicie
  }

  def execute(%Spicie{uuid: nil}, %CreateSpicie{} = command) do
    %SpiecieCreated{
      uuid: command.uuid,
      variety: command.variety,
      name: command.name,
      cultivation_days: command.cultivation_days
    }
  end

  def execute(%Spicie{}, %CreateSpicie{}), do: {:error, :already_registered}

  def execute(%Spicie{uuid: nil}, %AddStratumToSpicies{}), do: {:error, :spicie_not_found}

  def execute(%Spicie{}, %AddStratumToSpicies{} = command) do
    %StratumAddedToSpicie{
      uuid: command.uuid,
      stratum: command.stratum
    }
  end

  def execute(%Spicie{uuid: nil}, %AddStageToSpicies{}), do: {:error, :spicie_not_found}

  def execute(%Spicie{}, %AddStageToSpicies{} = command) do
    %StageAddedToSpicie{
      uuid: command.uuid,
      stage: command.stage
    }
  end

  def apply(_, %SpiecieCreated{} = evt) do
    %Spicie{
      uuid: evt.uuid,
      variety: evt.variety,
      name: evt.name,
      cultivation_days: evt.cultivation_days
    }
  end

  def apply(s, _), do: s
end
