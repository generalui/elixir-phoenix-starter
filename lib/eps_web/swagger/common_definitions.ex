defmodule EPSWeb.Swagger.CommonDefinitions do
  @moduledoc """
  Common swagger definitions used in multiple controllers.
  """

  require EPS.Enums

  use PhoenixSwagger
  use EPS.Constants.ErrorMessages

  alias EPS.Constants.Maps

  def errors do
    %{
      Error:
        swagger_schema do
          title("Error")
          description("Error response from the API")

          properties do
            code(
              :integer,
              "An app specific code applicable to this problem. Examples:\n#{
                Maps.app_codes(:string)
              }",
              required: false
            )

            detail(
              :string,
              "A human-readable explanation specific to this occurrence of the problem.",
              required: false
            )

            source(
              :json,
              "An object containing references to the source of the error, including the following member:\n`pointer`: a JSON Pointer [RFC6901] to the associated entity in the request document [e.g. '/data' for a primary data object, or '/data/attributes/title' for a specific attribute].",
              required: false
            )

            status(:string, "The HTTP status code applicable to this problem.", required: true)

            title(
              :string,
              "A short, human-readable summary of the problem that SHOULD NOT change from occurrence to occurrence of the problem.",
              required: true
            )
          end

          example(%{
            "code" => 42_200,
            "detail" => "Last name is invalid",
            "source" => %{
              "pointer" => "/data/attributes/lastName"
            },
            "status" => "422",
            "title" => "is invalid"
          })
        end,
      Errors:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            errors(
              Schema.new do
                description("A list of errors")
                type(:array)
                items(Schema.ref(:Error))
              end
            )
          end
        end
    }
  end

  def meta(_opts \\ []) do
    %{
      after: %Schema{
        type: :string,
        description: "The pagination cursor to use for retrieving records after the current page."
      },
      before: %Schema{
        type: :string,
        description:
          "The pagination cursor to use for retrieving records before the current page."
      },
      limit: %Schema{
        type: :integer,
        description: "The maximum number of records to return in a single page."
      },
      total_count: %Schema{
        type: :integer,
        description: "The total number of records to return in all pages combined."
      },
      total_count_cap_exceeded: %Schema{
        type: :integer,
        description: "A boolean indicating whether the `total_count_limit` was exceeded."
      }
    }
  end

  @doc """
  Defines a schema for a top level json-api document with an array of resources as primary data.
  The given `resource` should be the name of a JSON-API resource defined with the `resource/1` macro
  """
  def page(resource, meta \\ nil, included \\ nil) do
    %Schema{
      type: :object,
      description:
        "A page of [#{resource}](##{resource |> to_string |> String.downcase()}) results",
      properties:
        %{
          data: %Schema{
            type: :array,
            description:
              "Content with [#{resource}](##{resource |> to_string |> String.downcase()}) objects",
            items: %Schema{
              "$ref": "#/definitions/#{resource}"
            }
          }
        }
        |> add_meta(meta)
        |> add_included(included),
      required: [:data]
    }
    |> PhoenixSwagger.to_json()
  end

  ### PRIVATE ###

  defp add_included(properties, :included) do
    properties
    |> Map.merge(%{
      included: %Schema{
        type: :array,
        description: "Included resources referenced in the `relationships` property.",
        items: %Schema{
          type: :object,
          description: "An object with the related object's attributes.",
          properties: %{
            "attributes" => %Schema{
              type: :object,
              description: "An object with the related object's attributes."
            },
            "id" => %Schema{type: :string, description: "The related object's unique id."},
            "type" => %Schema{type: :string, description: "The type of related object."}
          }
        }
      }
    })
  end

  defp add_included(properties, _), do: properties

  defp add_meta(properties, nil), do: properties

  defp add_meta(properties, meta) do
    properties
    |> Map.merge(%{
      meta: %Schema{
        type: :object,
        description: "An object with information about the returned data.",
        properties: meta
      }
    })
  end
end
