defmodule RecomendationFront.Spicies.Domain.Entities.Spicie do
  use Ecto.Schema

  embedded_schema do
    field(:uuid, :binary_id)
    field(:variety, :string)
    field(:name, :string)
    field(:cultivation_days, :integer)
  end

  alias __MODULE__

  alias RecomendationFront.Spicies.Domain.Commands.CreateSpicie
  alias RecomendationFront.Spicies.Domain.Events.SpiecieCreated

  def execute(%Spicie{uuid: nil}, %CreateSpicie{} = command) do
    %SpiecieCreated{
      uuid: command.uuid,
      variety: command.variety,
      name: command.name,
      cultivation_days: command.cultivation_days
    }
  end

  def execute(%Spicie{}, %CreateSpicie{}), do: {:error, :already_registered}

  def apply(_, %SpiecieCreated{} = evt) do
    %Spicie{
      uuid: evt.uuid,
      variety: evt.variety,
      name: evt.name,
      cultivation_days: evt.cultivation_days
    }
  end
end
