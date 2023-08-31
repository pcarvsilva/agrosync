defmodule RecomendationFront.Infrastructure.Spicies.Router do
  use Commanded.Commands.Router

  alias RecomendationFront.Spicies.Domain.Entities.{Spicie, CropSchedule}

  alias RecomendationFront.Spicies.Domain.Commands.{
    CreateSpicie,
    ScheduleCrop,
    AddStratumToSpicies,
    AddStageToSpicies
  }

  identify(Spicie,
    by: :uuid,
    prefix: "spicie-"
  )

  identify(CropSchedule,
    by: :uuid,
    prefix: "crop-schedule-"
  )

  dispatch([AddStratumToSpicies, AddStageToSpicies, CreateSpicie], to: Spicie)
  dispatch(ScheduleCrop, to: CropSchedule)
end
