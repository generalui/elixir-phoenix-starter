defmodule EPS.Constants.General do
  @moduledoc """
  The Enums constants are where all enum values should be defined.
  """

  def current_env(), do: Application.fetch_env!(:eps, :env)

  def current_env(:string), do: current_env() |> to_string()

  defmacro __using__(_opts) do
    quote do
      # PermaJWT time to live == 99 years
      @perma_jwt_ttl {5_163, :weeks}
      @query_param_redirect_url "redirect_url"
      @pagination_high_limit "25000"
    end
  end
end
