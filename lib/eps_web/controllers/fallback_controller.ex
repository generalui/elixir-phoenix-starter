defmodule EPSWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """

  require Logger

  use EPSWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EPSWeb.ChangesetView)
    |> render("error.json-api", %{changeset: changeset, status: "422"})
    |> halt()
  end

  # This clause handles errors returned as a list.
  def call(conn, {:error, [_ | _] = errors}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EPSWeb.ErrorView)
    |> render("422.json-api", %{error: errors})
    |> halt()
  end

  # This clause handles general errors.
  def call(conn, {:error, error}) when is_binary(error) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(EPSWeb.ErrorView)
    |> render("422.json-api", %{error: error})
    |> halt()
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_view(EPSWeb.ErrorView)
    |> render("404.json-api", [])
    |> halt()
  end

  def call(conn, nil), do: call(conn, {:error, :not_found})

  def call(conn, params) do
    Logger.error(
      "Unhandled error in the FallbackController::\nconn: #{inspect(conn)}\n",
      ansi_color: :red
    )

    Logger.error(
      "Unhandled error in the FallbackController::\nparams: #{inspect(params)}\n",
      ansi_color: :red
    )

    conn
    |> put_status(500)
    |> put_view(EPSWeb.ErrorView)
    |> render("500.json-api", [])
    |> halt()
  end
end
