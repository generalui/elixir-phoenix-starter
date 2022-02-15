defmodule EPS.Schema do
  @moduledoc """
  Use for schemas to auto generate GUIDs instead of auto-incrementing integers as ids.
  In ecto schemas, `use EPS.Schema`.
  Creates timestamps with UTC datetime
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
      @timestamps_opts [type: :utc_datetime_usec]
      @derive {Phoenix.Param, key: :id}
    end
  end
end
