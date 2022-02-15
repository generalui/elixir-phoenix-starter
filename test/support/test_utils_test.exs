defmodule EPS.UtilsTest do
  @moduledoc """
  Tests for the Test Utilities.
  """

  use EPS.DataCase, async: true

  alias EPS.TestUtils

  describe "assert_location_values_equal" do
    test "passes when locations are equal" do
      location = %{lat: 123_456.09, long: 12345.09}

      location
      |> Recase.Enumerable.convert_keys(&Atom.to_string/1)
      |> TestUtils.assert_location_values_equal(location)
    end
  end

  describe "is_map_fully_replicated?" do
    test "it fails when any primitive properties in the original map are not the same in copied map" do
      map1 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3"}
      map2 = %{:key4 => "value4", :key5 => "value5", :key6 => "value6"}

      refute TestUtils.is_map_fully_replicated?(map1, map2)
    end

    test "it confirms all primitive properties in original map are contained in copied map" do
      map1 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3"}
      map2 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3", :key4 => "value4"}

      assert TestUtils.is_map_fully_replicated?(map1, map2)
    end
  end

  describe "props_are_equal?" do
    @base_props [:key1, :key2, :key3, :key4]

    test "returns true if input props are equal" do
      map1 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3", :key4 => "value4"}

      map2 = %{
        :key1 => "value1",
        :key2 => "value2",
        :key3 => "value3",
        :key4 => "value4",
        :key5 => "value5"
      }

      assert TestUtils.props_are_equal?(@base_props, map1, map2)
    end

    test "returns true if input props are equal when keys are not the same case or type" do
      map1 = %{
        :test_key1 => "value1",
        :test_key2 => "value2",
        :test_key3 => "value3",
        :test_key4 => "value4"
      }

      map2 = %{
        "test_key1" => "value1",
        "testKey2" => "value2",
        "test_key3" => "value3",
        "test_key4" => "value4",
        "test_key5" => "value5"
      }

      assert TestUtils.props_are_equal?(
               [:test_key1, :test_key2, :test_key3, :test_key4],
               map1,
               map2
             )
    end

    test "returns true if input props are equal but have different values when the prop is in the ignore list" do
      map1 = %{
        :test_key1 => :value1,
        :test_key2 => "value2",
        :test_key3 => "different_value3",
        :test_key4 => "value4"
      }

      map2 = %{
        "test_key1" => "value1",
        "testKey2" => "different_value2",
        "test_key3" => "value3",
        "test_key4" => :value4,
        "test_key5" => "value5"
      }

      assert TestUtils.props_are_equal?(
               [:test_key1, :test_key2, :test_key3, :test_key4],
               map1,
               map2,
               ["testKey3", :testKey2]
             )
    end

    test "returns false if an input prop is missing in one map" do
      map1 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3"}

      map2 = %{
        :key1 => "value1",
        :key2 => "value2",
        :key3 => "value3",
        :key4 => "value4",
        :key5 => "value5"
      }

      refute TestUtils.props_are_equal?(@base_props, map1, map2)
    end

    test "returns true if both maps are nil" do
      assert TestUtils.props_are_equal?(@base_props, nil, nil)
    end

    test "returns false if answers are different" do
      map1 = %{:key1 => "value1a", :key2 => "value2a", :key3 => "value3a", :key4 => "value4a"}

      map2 = %{
        :key1 => "value1",
        :key2 => "value2",
        :key3 => "value3",
        :key4 => "value4",
        :key5 => "value5"
      }

      refute TestUtils.props_are_equal?(@base_props, map1, map2)
    end

    test "returns true if answers are same" do
      map1 = %{:key1 => "value1", :key2 => "value2", :key3 => "value3", :key4 => "value4"}

      map2 = %{
        :key1 => "value1",
        :key2 => "value2",
        :key3 => "value3",
        :key4 => "value4",
        :key5 => "value5"
      }

      assert TestUtils.props_are_equal?(@base_props, map1, map2)
    end
  end
end
