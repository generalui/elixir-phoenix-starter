defmodule EPS.EctoEnumsTest do
  @moduledoc """
  Tests for the EctoEnums.
  """

  use EPS.DataCase
  use EPS.Constants.Enums

  alias EPS.EnvironmentEnum

  test "EnvironmentEnum has the values in the constant" do
    assert EnvironmentEnum.__enum_map__() == @environment_const
  end
end
