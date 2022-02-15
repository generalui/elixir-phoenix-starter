defmodule EPSWeb.JsonRestTest do
  @moduledoc """
  Tests for the JsonRest tools.
  """

  use EPS.DataCase, async: true

  import Mock

  alias Faker.Internet
  alias HTTPoison.Response
  alias EPSWeb.JsonRest

  @body %{"nice" => "body"}
  @url Internet.url()

  describe "get_json/2" do
    test "returns a response" do
      response = {:ok, %Response{body: %{"ok" => "yes"}, status_code: 200}}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert response == @url |> JsonRest.get_json([])
      end
    end

    test "returns an error tuple when the status code is higher than 299" do
      response = {:ok, %Response{body: %{"ok" => "yes"}, status_code: 401}}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert {:error, _} = @url |> JsonRest.get_json([])
      end
    end

    test "returns an error tuple when there is an error in the response" do
      response = {:error, "Some error message"}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert response == @url |> JsonRest.get_json([])
      end
    end
  end

  describe "post_json/3" do
    test "returns a response" do
      response = {:ok, %Response{body: %{"ok" => "yes"}, status_code: 200}}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert response == @url |> JsonRest.post_json([], @body)
      end
    end

    test "returns an error tuple when the status code is higher than 299" do
      response = {:ok, %Response{body: %{"ok" => "yes"}, status_code: 302}}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert {:error, _} = @url |> JsonRest.post_json([], @body)
      end
    end

    test "returns an error tuple when there is an error in the response" do
      response = {:error, "Some error message"}

      with_mocks [
        {HTTPoison, [], [start: fn -> nil end, request: fn _, _, _, _, _ -> response end]}
      ] do
        assert response == @url |> JsonRest.post_json([], @body)
      end
    end
  end
end
