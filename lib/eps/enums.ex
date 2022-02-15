defmodule EPS.Enums do
  @moduledoc """
  The Enum provides a location for all enum related macros.
  """

  use EPS.Constants.Enums

  defmacro environment_const, do: Macro.expand(@environment_const, __CALLER__)
end
