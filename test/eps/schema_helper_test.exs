defmodule EPS.SchemaHelperTest do
  @moduledoc """
  Tests for the SchemaHelper.
  """

  use ExUnit.Case

  require EPS.Enums

  import Ecto.Changeset
  import Mock

  alias EPS.{SchemaHelper, UUID}

  describe "ensure_map/1" do
    defmodule TestStruct do
      @moduledoc """
      Test Struct
      """
      defstruct id: Ecto.UUID.generate()
    end

    test "converts the passed struct to a map" do
      assert %TestStruct{} |> SchemaHelper.ensure_map() |> is_map()
      refute %TestStruct{} |> SchemaHelper.ensure_map() |> is_struct()
    end

    test "returns the passed map" do
      assert %{} |> SchemaHelper.ensure_map() |> is_map()
      refute %{} |> SchemaHelper.ensure_map() |> is_struct()
    end

    test "returns a map when nil is passed" do
      assert nil |> SchemaHelper.ensure_map() |> is_map()
    end
  end

  describe "generate_id/1" do
    @id MACAddress.broadcast_address() |> MACAddress.to_hex()

    test "generates a GUID for an ID if no ID is passed" do
      data = %{}
      types = %{id: :string}
      params = %{}
      changeset = {data, types} |> cast(params, Map.keys(types)) |> SchemaHelper.generate_id()

      assert changeset |> get_field(:id) |> UUID.is_guid?()
    end

    test "does not generate a GUID for an ID if an ID is passed" do
      data = %{}
      types = %{id: :string}
      params = %{id: @id}
      changeset = {data, types} |> cast(params, Map.keys(types)) |> SchemaHelper.generate_id()

      assert changeset |> get_field(:id) == @id
    end

    test "does nothing if the changeset is invalid" do
      data = %{}
      types = %{id: :integer}
      params = %{}
      changeset = {data, types} |> cast(params, Map.keys(types))
      changeset |> SchemaHelper.generate_id()

      assert changeset |> get_field(:id) == nil
    end
  end

  describe "validate_required_inclusion/2" do
    test "returns a valid changeset when at least one required field is passed" do
      data = %{}
      types = %{id: :string, value_1: :string, value_2: :string}
      params = %{value_1: "test"}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))
        |> SchemaHelper.validate_required_inclusion([:value_1, :value_2])

      assert changeset.valid?
    end

    test "returns an invalid changeset when no required fields are passed" do
      data = %{}
      types = %{id: :string, value_1: :string, value_2: :string}
      params = %{}

      changeset =
        {data, types}
        |> cast(params, Map.keys(types))
        |> SchemaHelper.validate_required_inclusion([:value_1, :value_2])

      refute changeset.valid?
    end
  end
end
