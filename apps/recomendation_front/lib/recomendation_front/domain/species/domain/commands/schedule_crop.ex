defmodule RecomendationFront.Spicies.Domain.Commands.ScheduleCrop do
  use Commanded.DDD.Command

  command do
    [
      uuid: :binary_id,
      spiecie_uuid: :binary_id,
      territory_uuid: :binary_id,
      date: :date,
      cultivation_days: :integer,
      spiecie_variety: :string
    ]
  end

  def handle_validate(changeset) do
    changeset
    |> validate_required([
      :uuid,
      :spiecie_uuid,
      :territory_uuid,
      :date,
      :cultivation_days,
      :spiecie_variety
    ])
    |> validate_number(:cultivation_days, greater_than: 0)
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
