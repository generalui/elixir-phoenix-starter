defmodule EPS.UUID do
  @moduledoc """
  UUID and GUID helpers.
  """

  @doc """
  Tests if the passed value is a valid GUID (version 1, 2, 3, 4, or 5).
  Returns boolean true if it is and boolean false if it is not.

  ## Examples

      iex> is_guid?("ec71f7e0-7264-4fc2-ac02-d77322aeca3c")
      true

      iex> is_guid?("Not-a-guid")
      false

  """
  def is_guid?(guid) do
    String.match?(guid, ~r/^[\dA-F]{8}-([\dA-F]{4}-){3}[\dA-F]{12}$/i)
  end
end
