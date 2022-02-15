defmodule EPS.Constants.MapsTest do
  @moduledoc """
  Tests for the maps constants functions
  """

  use EPS.DataCase, async: true

  alias EPS.Constants.Maps

  describe "maps" do
    test "alert_source_desired_firmware_version/0 returns a maps" do
      assert Maps.alert_source_desired_firmware_version() |> is_map()
    end

    test "alert_source_desired_firmware_version/1 returns a stringified JSON of the map" do
      assert Maps.alert_source_desired_firmware_version(:string) |> is_binary()
    end

    test "alert_source_props/0 returns a maps" do
      assert Maps.alert_source_props() |> is_map()
    end

    test "alert_source_props/1 returns a stringified JSON of the map" do
      assert Maps.alert_source_props(:string) |> is_binary()
    end

    test "alert_source_version/0 returns a maps" do
      assert Maps.alert_source_version() |> is_map()
    end

    test "alert_source_version/1 returns a stringified JSON of the map" do
      assert Maps.alert_source_version(:string) |> is_binary()
    end

    test "app_codes/0 returns a maps" do
      assert Maps.app_codes() |> is_map()
    end

    test "app_codes/1 returns a stringified JSON of the map" do
      assert Maps.app_codes(:string) |> is_binary()
    end

    test "beacon_desired_firmware_version/0 returns a maps" do
      assert Maps.beacon_desired_firmware_version() |> is_map()
    end

    test "beacon_desired_firmware_version/1 returns a stringified JSON of the map" do
      assert Maps.beacon_desired_firmware_version(:string) |> is_binary()
    end

    test "beacon_props/0 returns a maps" do
      assert Maps.beacon_props() |> is_map()
    end

    test "beacon_props/1 returns a stringified JSON of the map" do
      assert Maps.beacon_props(:string) |> is_binary()
    end

    test "beacon_version/0 returns a maps" do
      assert Maps.beacon_version() |> is_map()
    end

    test "beacon_version/1 returns a stringified JSON of the map" do
      assert Maps.beacon_version(:string) |> is_binary()
    end

    test "button_props/0 returns a maps" do
      assert Maps.button_props() |> is_map()
    end

    test "button_props/1 returns a stringified JSON of the map" do
      assert Maps.button_props(:string) |> is_binary()
    end

    test "button_version/0 returns a maps" do
      assert Maps.button_version() |> is_map()
    end

    test "button_version/1 returns a stringified JSON of the map" do
      assert Maps.button_version(:string) |> is_binary()
    end

    test "external_integration_props/0 returns a maps" do
      assert Maps.external_integration_props() |> is_map()
    end

    test "external_integration_props/1 returns a stringified JSON of the map" do
      assert Maps.external_integration_props(:string) |> is_binary()
    end

    test "org_props/0 returns a maps" do
      assert Maps.org_props() |> is_map()
    end

    test "org_props/1 returns a stringified JSON of the map" do
      assert Maps.org_props(:string) |> is_binary()
    end
  end
end
