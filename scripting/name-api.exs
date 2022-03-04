#! /usr/bin/env elixir

Mix.install([
  {:httpoison, "~> 1.8"},
  {:poison, "~> 5.0"}
])

defmodule Sample do
  require Logger

  @agify "https://api.agify.io/?name="
  @genderize "https://api.genderize.io/?name="
  @nationalize "https://api.nationalize.io/?name="

  def get_api_data(api_url, name) do
    api_url = "#{api_url}#{name}"

    with {:ok, response} <- HTTPoison.request(:get, api_url, [], timeout: 2000),
         %{status_code: 200, body: body} <- response,
         {:ok, data} <- Poison.decode(body) do
      extract_data(data)
    else
      {:error, reason} ->
        Logger.error("Error #{inspect(reason)}")
        {:error, :http_call}

      %{status_code: status_code} ->
        Logger.warn("Error en la llamada http: #{status_code}")
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
    # |> Task.async_stream(fn api -> get_api_data(api, name) end)
    [@agify, @genderize, @nationalize]
    |> Task.async_stream(&get_api_data(&1, name))
    |> Stream.map(&elem(&1, 1))
    |> Map.new()
  end

  def run(names) do
    names
    |> String.split(",")
    |> Task.async_stream(&{&1, get_name_info(&1)})
    |> Stream.map(&elem(&1, 1))
    |> Map.new()
  end
end

IO.inspect(Sample.run("david,luis,maria,marta,miqui"))
