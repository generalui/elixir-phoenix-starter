defmodule EPS.Constants.Maps do
  @moduledoc """
  The maps constants are where all constants that are map values should be defined.
  """

  def app_codes() do
    %{
      "expired_jwt" => 40_101,
      "invalid_user" => 40_102,
      "re_authenticate" => 40_104
    }
  end

  def app_codes(:string), do: app_codes() |> stringify_map()

  ### PRIVATE ###

  defp stringify_map(map) do
    {:ok, json} = map |> Jason.encode()
    json |> Jason.Formatter.pretty_print()
  end
end
