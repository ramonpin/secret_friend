#! /usr/bin/env elixir

Mix.install([
  {:httpoison, "~> 1.8"},
  {:poison, "~> 5.0"},
  {:plug_cowboy, "~> 2.0"}
])

defmodule Sample do
  require Logger

  @agify "https://api.agify.io/?name="
  @genderize "https://api.genderize.io/?name="
  @nationalize "https://api.nationalize.io/?name="

  def get_api_data(api_url, name) do
    api_url = "#{api_url}#{name}"

    with {:ok, response} <- HTTPoison.get(api_url, [], timeout: 2000),
         %{status_code: 200, body: body} <- response,
         {:ok, data} <- Poison.decode(body) do
      extract_data(data)
    else
      {:error, reason} ->
        Logger.error("Error #{inspect(reason)}")
        {:error, :http_call}

      %{status_code: status_code} ->
        Logger.error("Error en la llamada http: #{status_code}")
        {:error, :http_status}

      _ ->
        Logger.error("Error inesperado")
        {:error, :unkown}
    end
  end

  defp extract_data(%{"age" => age}), do: {:age, age}
  defp extract_data(%{"gender" => gender}), do: {:gender, gender}
  defp extract_data(%{"country" => country}), do: {:country, country}
  defp extract_data(_), do: :unknown

  def get_name_info(name) do
    [@agify, @genderize, @nationalize]
    |> Task.async_stream(fn api -> get_api_data(api, name) end)
    |> Stream.map(fn {:ok, data} -> data end)
    |> Map.new()
  end
  
  def get_all_names_info(names) do
    names
    |> Task.async_stream(fn name -> {name, get_name_info(name)} end)
    |> Stream.map(fn {:ok, data} -> data end)
    |> Map.new()
  end
end

# Call the APIs
IO.puts("Lucas info")
IO.puts("-------------------------------------------------------")
IO.inspect(Sample.get_name_info("Lucas"))
IO.puts("")
IO.puts("Juan, Maria, Luis concurrent call for info")
IO.puts("-------------------------------------------------------")
IO.inspect(Sample.get_all_names_info(["Juan", "Maria", "Luis"]))
