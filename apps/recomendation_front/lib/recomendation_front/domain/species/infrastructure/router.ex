defmodule RecomendationFront.Infrastructure.Spicies.Router do
  use Commanded.Commands.Router

  alias RecomendationFront.Spicies.Domain.Entities.{Spicie, CropSchedule}
  alias RecomendationFront.Spicies.Domain.Commands.{CreateSpicie, ScheduleCrop}

  identify(Spicie,
    by: :uuid,
    prefix: "spicie-"
  )

  identify(CropSchedule,
    by: :uuid,
    prefix: "crop-schedule-"
  )

  dispatch(CreateSpicie, to: Spicie)
  dispatch(ScheduleCrop, to: CropSchedule)
end
