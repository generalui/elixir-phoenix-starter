defmodule EPS.ContextHelperTest do
  @moduledoc """
  Tests for the ContextHelper.
  """

  use EPS.DataCase

  import Ecto.Query, warn: false

  alias Faker.Person
  alias Paginator.Page
  alias EPS.ContextHelper

  describe "build_pagination_options/3" do
    test "adds `limit` to the options" do
      limit = 3

      assert [limit: limit, after: nil] ==
               []
               |> ContextHelper.build_pagination_options(nil, %{"limit" => limit |> to_string()})
    end

    test "adds `after` to the options from the filters" do
      not_after_cursor = "not_after_cursor"
      after_cursor = "after_cursor"

      assert [after: after_cursor] ==
               []
               |> ContextHelper.build_pagination_options(not_after_cursor, %{
                 "after_cursor" => after_cursor
               })
    end

    test "adds `before` to the options from the filters" do
      not_after_cursor = "not_after_cursor"
      before_cursor = "before_cursor"

      assert [before: before_cursor] ==
               []
               |> ContextHelper.build_pagination_options(not_after_cursor, %{
                 "before_cursor" => before_cursor
               })
    end
  end

  describe "compile_paginated_results/2" do
    def list_function(_, nil) do
      %Page{
        entries: 1..10 |> Enum.to_list(),
        metadata: %Page.Metadata{after: "cursor", limit: 10, total_count: 20}
      }
    end

    def list_function(_, "cursor") do
      %Page{
        entries: 11..20 |> Enum.to_list(),
        metadata: %Page.Metadata{after: nil, limit: 10, total_count: 20}
      }
    end

    test "returns compiled results" do
      assert 1..20 |> Enum.to_list() == ContextHelper.compile_paginated_results(&list_function/2)

      assert 1..20 |> Enum.to_list() ==
               ContextHelper.compile_paginated_results(&list_function/2, %{})
    end
  end

  describe "filter_ids/3" do
    test "returns the query unchanged" do
      query = from(tm in TestModel)
      assert query == query |> ContextHelper.filter_ids(:test_model, %{})
      assert query == query |> ContextHelper.filter_ids(:test_model, nil)
      assert query == query |> ContextHelper.filter_ids(:test_model, [])
      assert query == query |> ContextHelper.filter_ids(:test_model, [nil])
    end

    test "with a list of ids returns the query with the id filter" do
      ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]
      query = from(tm in TestModel, as: :test_model)

      assert %Ecto.Query{
               aliases: %{test_model: 0},
               from: %Ecto.Query.FromExpr{
                 as: :test_model,
                 source: {"test_models", TestModel}
               },
               wheres: [
                 %Ecto.Query.BooleanExpr{params: [{returned_ids, {:in, {0, :id}}}]}
               ]
             } = query |> ContextHelper.filter_ids(:test_model, %{"ids" => ids})

      assert returned_ids == ids
    end

    test "with a single id returns the query with the org filter" do
      id = Ecto.UUID.generate()
      query = from(tm in TestModel, as: :test_model)

      assert %Ecto.Query{
               aliases: %{test_model: 0},
               from: %Ecto.Query.FromExpr{
                 as: :test_model,
                 source: {"test_models", TestModel}
               },
               wheres: [
                 %Ecto.Query.BooleanExpr{
                   params: [{returned_ids, {:in, {0, :id}}}]
                 }
               ]
             } = query |> ContextHelper.filter_ids(:test_model, %{"ids" => id})

      assert returned_ids == [id]
    end
  end

  describe "get/2" do
    test "returns the value using an atom when the key is a string" do
      value = "value"
      assert value == %{"key" => value} |> ContextHelper.get(:key)
    end

    test "returns the value using a string when the key is an atom" do
      value = "value"
      assert value == %{key: value} |> ContextHelper.get("key")
    end

    test "returns the nil when the key doesn't exist" do
      assert nil == %{key: "value"} |> ContextHelper.get("not_the_key")
    end

    test "returns the default when the key doesn't exist" do
      default = "default"
      assert default == %{key: "value"} |> ContextHelper.get("not_the_key", default)
    end
  end

  describe "keep_matching_ids" do
    test "removes all items that don't have matching ids" do
      object1 = %{id: Ecto.UUID.generate()}
      object2 = %{id: Ecto.UUID.generate()}
      object3 = %{id: Ecto.UUID.generate()}
      removable = [object1, object2]
      comparable = [object3, object1]
      assert ContextHelper.keep_matching_ids(removable, comparable, :id, :id) == [object1]
    end

    test "removes all items that don't have matching ids with different keys" do
      id1 = Ecto.UUID.generate()
      object1 = %TestModel{field: id1}
      object2 = %TestModel{field: Ecto.UUID.generate()}
      object3 = %{"crazy_key" => Ecto.UUID.generate()}
      object4 = %{"crazy_key" => id1}
      removable = [object1, object2]
      comparable = [object3, object4]

      assert ContextHelper.keep_matching_ids(removable, comparable, :field, "crazy_key") == [
               object1
             ]
    end
  end

  describe "remove_duplicate_ids" do
    test "removes all items that have matching ids" do
      object1 = %{id: Ecto.UUID.generate()}
      object2 = %{id: Ecto.UUID.generate()}
      object3 = %{id: Ecto.UUID.generate()}
      removable = [object1, object2]
      comparable = [object3, object2]
      assert ContextHelper.remove_duplicate_ids(removable, comparable, :id, :id) == [object1]
    end

    test "removes all items that have matching ids with different keys" do
      id1 = Ecto.UUID.generate()
      object1 = %TestModel{field: id1}
      object2 = %TestModel{field: Ecto.UUID.generate()}
      object3 = %{"crazy_key" => Ecto.UUID.generate()}
      object4 = %{"crazy_key" => id1}
      removable = [object1, object2]
      comparable = [object3, object4]

      assert ContextHelper.remove_duplicate_ids(removable, comparable, :field, "crazy_key") == [
               object2
             ]
    end
  end

  describe "user_name" do
    test "returns the user's full name" do
      first_name = Person.first_name()
      last_name = Person.last_name()
      assert ContextHelper.user_name(first_name, last_name) == "#{first_name} #{last_name}"
    end

    test "returns the user's first name with no spaces when the last name isn't available" do
      first_name = Person.first_name()
      assert ContextHelper.user_name(first_name, nil) == first_name
    end

    test "returns the user's last name with no spaces when the first name isn't available" do
      last_name = Person.last_name()
      assert ContextHelper.user_name(nil, last_name) == last_name
    end

    test "returns an empty string when no name is available" do
      assert ContextHelper.user_name(nil, nil) == ""
    end
  end
end
