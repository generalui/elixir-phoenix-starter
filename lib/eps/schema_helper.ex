defmodule EPS.SchemaHelper do
  @moduledoc """
  Helpers for use in schemas.
  """
  require Logger

  import Ecto.Changeset

  def ensure_map(nil), do: %{}

  def ensure_map(term) when is_struct(term),
    do: term |> Map.from_struct() |> Map.delete(:__meta__)

  def ensure_map(term), do: term

  @doc """
  Generates a GUID as an ID if an ID wasn't passed.
  If the passed changeset is already invalid, it passes the changeset through without creating an ID.
  """
  def generate_id(changeset) when changeset.valid? do
    id = changeset |> get_field(:id) || Ecto.UUID.generate()

    current_changes = changeset.changes
    # Apply the changes to the changeset.
    %{changeset | changes: current_changes |> Map.put(:id, id)}
  end

  def generate_id(changeset), do: changeset

  @doc """
  Ensures the passed value is lowercase.
  If the passed changeset is already invalid, it passes the changeset through.
  """
  def to_lowercase(changeset, field) when changeset.valid? do
    changeset
    |> get_change(field)
    |> case do
      nil ->
        changeset

      value ->
        current_changes = changeset.changes
        value = value |> String.downcase()
        # Apply the changes to the changeset.
        %{changeset | changes: current_changes |> Map.merge(%{field => value})}
    end
  end

  def to_lowercase(changeset, _), do: changeset

  def validate_required_inclusion(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      # Add the error to the first field only since Ecto requires a field name for each error.
      add_error(changeset, hd(fields), "One of these fields must be present: #{inspect(fields)}")
    end
  end

  ### PRIVATE ###

  defp present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
