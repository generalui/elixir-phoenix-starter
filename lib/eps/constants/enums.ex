defmodule EPS.Constants.Enums do
  @moduledoc """
  The Enums constants are where all enum values should be defined.
  """

  defmacro __using__(_opts) do
    quote do
      @environment_const [:dev, :prod, :staging, :test]
      @provider_const [
        :apple,
        :auth0,
        :facebook,
        :github,
        :google,
        :microsoft,
        :okta,
        :ping,
        :slack,
        :twitter
      ]
    end
  end
end
