defmodule EPSWeb.ErrorHelpersTest do
  @moduledoc """
  Tests for the error helpers.
  """

  use EPSWeb.ConnCase, async: true

  import EPSWeb.ErrorHelpers

  test "returns error message" do
    message = "is invalid"
    assert translate_error({message, %{}}) == message
    assert translate_error({message, %{count: 1}}) == message
  end
end
