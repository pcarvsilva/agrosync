defmodule RecomendationFront.Spicies.UseCases.FetchSpiciesFromIsla do
  alias RecomendationFront.Spicies.UseCases.CreateSpicie

  @default_path "/apps/recomendation_front/priv/repo/species_isla.csv"

  def execute(params \\ %{}) do
    path = File.cwd!() <> (params[:file] || @default_path)

    File.stream!(path)
    |> CSV.decode!()
    |> Stream.map(fn row ->
      %{
        "variety" => row |> Enum.at(1) |> String.downcase() |> Macro.camelize(),
        "name" => row |> Enum.at(3) |> String.downcase(),
        "cultivation_days" =>
          row
          |> Enum.at(8)
          |> Integer.parse()
          |> case do
            {n, _} -> n
            n -> n
          end
      }
      |> CreateSpicie.execute()
    end)
    |> Stream.filter(fn a -> a != :ok end)
    |> Enum.to_list()
  end
end
