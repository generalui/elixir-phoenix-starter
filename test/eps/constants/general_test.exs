defmodule EPS.Constants.GeneralTest do
  @moduledoc """
  Tests for the general constants functions
  """

  use EPS.DataCase, async: true

  alias EPS.Constants.General

  describe "general" do
    test "current_env/0 returns the current environment" do
      assert :test == General.current_env()
    end

    test "current_env/1 returns the current environment as a string" do
      assert "test" == General.current_env(:string)
    end
  end
end
