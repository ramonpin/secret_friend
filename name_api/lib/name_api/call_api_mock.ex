defmodule NameApi.CallApiMock do
  def get_name_info(_name) do
    %{
      "age" => 25,
      "gender" => "male",
      "country" => [%{"probability" => 1, "country_id" => "ES"}]
    }
  end

  def get_all_names_info(names) do
    names
    |> Enum.map(fn name -> {name, get_name_info(name)} end)
    |> Map.new()
  end
end
