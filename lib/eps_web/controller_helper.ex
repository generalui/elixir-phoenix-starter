defmodule EPSWeb.ControllerHelper do
  @moduledoc """
  Helper functions for controllers.
  """

  require EPS.Enums

  use EPS.Constants.General

  def maybe_reduce_map_to_nil(map) do
    map
    |> case do
      map when map == %{} -> nil
      map -> map
    end
  end

  def merge_property(old_map, new_map, property) do
    value = new_map |> Map.get(property, %{})

    value
    |> case do
      nil ->
        nil

      value when value |> is_map() ->
        old_map
        |> Map.get(property, %{})
        |> Map.merge(value)
        |> remove_nils_from_map()
        |> maybe_reduce_map_to_nil()
    end
  end

  def recursive_keys_to_camel_string(map, key, exclude_children \\ []) do
    map
    |> Map.get(key)
    |> case do
      nil -> map
      value -> %{map | key => value |> camel_string_with_exclusions(exclude_children)}
    end
  end

  def remove_nils_from_map(map) do
    :maps.filter(fn _, v -> v != nil end, map)
  end

  ### PRIVATE ###

  defp camel_string_with_exclusions(value, exclude_children)
       when value |> is_map() and exclude_children != [] do
    camelized_stringed_map = value |> camel_string_with_exclusions([])

    exclude_children
    |> Enum.reduce(camelized_stringed_map, fn child_key, acc ->
      value
      |> Map.get(child_key)
      |> case do
        nil ->
          acc

        child_value ->
          child_value = child_value |> stringify_keys()
          string_child_key = child_key |> to_string()
          camel_string_child_key = string_child_key |> Recase.to_camel()

          acc
          |> Map.delete(camel_string_child_key)
          |> Map.merge(%{string_child_key => child_value})
      end
    end)
  end

  defp camel_string_with_exclusions(value, _) when value |> is_map() do
    value |> Recase.Enumerable.stringify_keys(&Recase.to_camel/1)
  end

  defp camel_string_with_exclusions(value, _), do: value

  defp stringify_keys(value) when value |> is_map() do
    value |> Recase.Enumerable.stringify_keys()
  end

  defp stringify_keys(value), do: value
end
