defmodule NameApi do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Rest.Router, options: [port: port()]},
      {Task.Supervisor, name: WebService.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: NameApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port() do
    port = Application.get_env(:name_api, :port)
    Logger.debug("Starting in port #{port}")
    port
  end
end
