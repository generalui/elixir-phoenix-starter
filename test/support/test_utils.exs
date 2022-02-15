defmodule EPS.TestUtils do
  @moduledoc """
  Test Utility functions.
  """

  use EPS.DataCase

  alias EPS.SchemaHelper

  def assert_location_values_equal(location_json, location_db) do
    assert location_json["floor"] == location_db.floor
    assert location_json["integration"] == location_db.integration
    assert location_json["lat"] == location_db.lat
    assert location_json["long"] == location_db.long
    assert location_json["property"] == location_db.property
    assert location_json["room"] == location_db.room
  end

  def is_map_fully_replicated?(original_map, new_map) do
    original_map
    |> Enum.reduce(true, fn {key, item}, accum ->
      new_map
      |> Map.get(key)
      |> is_equal?(item)
      |> case do
        true -> accum
        false -> false
      end
    end)
  end

  def props_are_equal?(props, map1, map2, ignore \\ [])
  def props_are_equal?(_, nil, nil, _), do: true
  def props_are_equal?(_, nil, _, _), do: false
  def props_are_equal?(_, _, nil, _), do: false

  def props_are_equal?(props, map1, map2, ignore) do
    ignore = ignore |> Enum.map(fn value -> value |> to_string() |> Recase.to_camel() end)

    map1 =
      map1 |> SchemaHelper.ensure_map() |> Recase.Enumerable.stringify_keys(&Recase.to_camel/1)

    map2 =
      map2 |> SchemaHelper.ensure_map() |> Recase.Enumerable.stringify_keys(&Recase.to_camel/1)

    props
    |> Enum.all?(fn prop ->
      prop = prop |> to_string() |> Recase.to_camel()

      if prop in ignore do
        true
      else
        Map.get(map1, prop) |> is_equal?(Map.get(map2, prop))
      end
    end)
  end

  defp is_equal?(%DateTime{} = one, %DateTime{} = two) do
    Timex.diff(one, two, :second) <= 1
  end

  defp is_equal?(one, two) when is_atom(one), do: is_equal?(one |> to_string, two)
  defp is_equal?(one, two) when is_atom(two), do: is_equal?(one, two |> to_string)
  defp is_equal?(one, two), do: one === two
end
