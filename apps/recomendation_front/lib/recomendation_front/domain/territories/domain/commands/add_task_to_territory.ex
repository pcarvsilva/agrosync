defmodule RecomendationFront.Territories.Domain.Commands.AddTaskToTerritory do
  use Commanded.DDD.Command

  command do
    [
      uuid: :binary_id,
      description: :string,
      date: :date
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([:uuid, :description, :date])
    |> validate_length(:description, min: 4, max: 35)
    |> validate_is_not_past_date(:date)
  end

  defp validate_is_not_past_date(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, date ->
      case Timex.before?(date, Timex.today()) do
        false -> []
        true -> [{field, options[:message] || "Essa data já passou"}]
      end
    end)
  end
end
