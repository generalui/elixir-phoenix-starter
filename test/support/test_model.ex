defmodule EPS.TestModel do
  @moduledoc """
  Test Model
  """
  use EPS.Schema

  schema "test_models" do
    field :field, :string
  end
end
