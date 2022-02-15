defmodule EPS.UUIDTest do
  @moduledoc """
  Tests for the UUID helpers.
  """

  use ExUnit.Case

  alias EPS.UUID

  test "is_guid?/1 returns true with valid guid" do
    assert UUID.is_guid?(Ecto.UUID.generate())
  end

  test "is_guid?/1 returns false with invalid guid" do
    refute UUID.is_guid?("Not-a-guid")
    refute UUID.is_guid?("ec71f7e0-7264-5fc-ac02-d77322aeca3c")
    refute UUID.is_guid?("ec71g7e0-7264-5fcf-ac02-d77322aeca3c")
  end
end
