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
