defmodule EPS.ContextHelper do
  @moduledoc """
  Helper functions for contexts.
  """

  import Ecto.Query, warn: false

  alias Paginator.Page

  def build_pagination_options(default_opts, after_cursor, filters) do
    default_opts |> add_limit(filters) |> add_cursor(after_cursor, filters)
  end

  def compile_paginated_results(list_function, args \\ %{}) do
    %Page{
      entries: entries,
      metadata: %Page.Metadata{after: after_cursor, limit: limit, total_count: total_count}
    } = list_function.(args, nil)

    {_cursor, entries} =
      if after_cursor do
        1..trunc(Float.ceil(total_count / limit))
        |> get_paginated_results(list_function, after_cursor, entries, args)
      else
        {nil, entries}
      end

    entries
  end

  def filter_ids(query, as, %{"ids" => id}) when is_binary(id) do
    query |> filter_ids(as, %{"ids" => [id]})
  end

  def filter_ids(query, as, %{"ids" => ids}) do
    from([{^as, x}] in query, where: x.id in ^ids)
  end

  def filter_ids(query, _, _), do: query

  def get(map, key, default \\ nil)

  def get(map, key, default) when is_atom(key) do
    get(map, to_string(key), default)
  end

  def get(map, key, default) do
    map |> Recase.Enumerable.stringify_keys() |> Map.get(key, default)
  end

  def keep_matching_ids(remove_from, compare_to, from_field, compare_field) do
    remove_from
    |> Enum.reduce([], fn item, acc ->
      item_field = item |> Map.get(from_field)

      compare_to
      |> Enum.find(false, fn comparable ->
        item_field == comparable |> Map.get(compare_field)
      end)
      |> case do
        false -> acc
        _ -> [item | acc]
      end
    end)
  end

  def remove_duplicate_ids(remove_from, compare_to, from_field, compare_field) do
    remove_from
    |> Enum.reduce([], fn item, acc ->
      item_field = item |> Map.get(from_field)

      compare_to
      |> Enum.find(false, fn comparable ->
        item_field == comparable |> Map.get(compare_field)
      end)
      |> case do
        false -> [item | acc]
        _ -> acc
      end
    end)
  end

  def user_name(first_name, last_name) do
    Enum.join([first_name, last_name], " ") |> String.trim()
  end

  ### PRIVATE ###

  defp add_cursor(opts, _, %{"after_cursor" => after_cursor}) do
    opts |> Keyword.merge(after: after_cursor)
  end

  defp add_cursor(opts, _, %{"before_cursor" => before_cursor}) do
    opts |> Keyword.merge(before: before_cursor)
  end

  defp add_cursor(opts, after_cursor, _) do
    opts |> Keyword.merge(after: after_cursor)
  end

  defp add_limit(opts, %{"limit" => limit}) do
    opts |> Keyword.merge(limit: limit |> String.to_integer())
  end

  defp add_limit(opts, _), do: opts

  defp get_paginated_results(iterable, list_function, after_cursor, entries, args) do
    iterable
    |> Enum.reduce_while({after_cursor, entries}, fn _, {a_cursor, list} ->
      if a_cursor == nil do
        {:halt, {nil, list}}
      else
        %Page{entries: latest_list, metadata: %Page.Metadata{after: cursor}} =
          list_function.(args, a_cursor)

        {:cont, {cursor, list ++ latest_list}}
      end
    end)
  end
end
