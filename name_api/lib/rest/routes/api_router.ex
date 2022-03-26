defmodule Rest.Routes.ApiRouter do
  use Plug.Router

  require Logger

  @call_api Application.get_env(:name_api, :call_api)

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  defp send_resp_json(conn, code, data) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> send_resp(code, Poison.encode!(data))
  end

  get "/name/:name" do
    send_resp_json(conn, 200, @call_api.get_name_info(name))
  end

  get "/names/:names" do
    names = String.split(names, ",")

    Logger.debug("The names are #{inspect(names)}")
    send_resp_json(conn, 200, @call_api.get_all_names_info(names))
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end
end
