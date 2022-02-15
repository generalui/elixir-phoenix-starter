defmodule EPS.Constants.MapsTest do
  @moduledoc """
  Tests for the maps constants functions
  """

  use EPS.DataCase, async: true

  alias EPS.Constants.Maps

  describe "maps" do
    test "app_codes/0 returns a maps" do
      assert Maps.app_codes() |> is_map()
    end

    test "app_codes/1 returns a stringified JSON of the map" do
      assert Maps.app_codes(:string) |> is_binary()
    end
  end
end
