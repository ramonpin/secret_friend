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
    WebService.Supervisor
    |> Task.Supervisor.async_stream([@agify, @genderize, @nationalize], &get_api_data(&1, name))
    |> Stream.map(&elem(&1, 1))
    |> Map.new()
  end
  
  def get_all_names_info(names) do
    WebService.Supervisor
    |> Task.Supervisor.async_stream(names, &{&1, get_name_info(&1)})
    |> Stream.map(&elem(&1, 1))
    |> Map.new()
  end
end

defmodule Rest.Routes.ApiRouter do
  use Plug.Router

  require Logger

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  defp send_resp_json(conn, code, data) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(code, Poison.encode!(data))
  end

  get "/name/:name" do
    send_resp_json(conn, 200, Sample.get_name_info(name))
  end

  get "/names/:names" do
    names = String.split(names, ",")

    Logger.debug("The names are #{inspect(names)}")
    send_resp_json(conn, 200, Sample.get_all_names_info(names))
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end

defmodule Rest.Router do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  forward("/api", to: Rest.Routes.ApiRouter)

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end

defmodule Server do
  def run_server do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Rest.Router, options: [port: 3000]},
      {Task.Supervisor, name: WebService.Supervisor}
    ]
    
    Supervisor.start_link(children, strategy: :one_for_one, name: WebServiceApp.Supervisor)
  end
end

{:ok, server} = Server.run_server()
IO.inspect(Process.info(server))
