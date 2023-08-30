defmodule RecomendationFront.Repo do
  use Ecto.Repo,
    otp_app: :recomendation_front,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
