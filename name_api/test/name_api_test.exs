defmodule NameApiTest do
  use ExUnit.Case
  doctest NameApi

  test "gets name data" do
    case HTTPoison.get("http://localhost:3000/api/name/ramon") do
      {:ok, %{body: body}} -> assert %{"age" => 25} = Poison.decode!(body)
      _ -> assert 1 == 2
    end
  end
end
