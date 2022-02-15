# Define all enums specifically for Ecto.

import EctoEnum

require EPS.Enums

defenum(
  EPS.EnvironmentEnum,
  :environment_enum,
  EPS.Enums.environment_const()
)
