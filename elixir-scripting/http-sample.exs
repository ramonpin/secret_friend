#! /usr/bin/env elixir

Mix.install([
  {:httpoison, "~> 1.8"},
  {:poison, "~> 5.0"}
])

defmodule Sample do
  require Logger

  @api_base "http://api.coindesk.com/v1"
  @api_url "#{@api_base}/bpi/currentprice.json"

  def get_bpi() do
    with {:ok, response} <- HTTPoison.request(:get, @api_url, [], timeout: 2000),
         %{status_code: 200, body: body} <- response,
         {:ok, data} <- Poison.decode(body) do
      data["bpi"]
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
end

IO.inspect(Sample.get_bpi())
