defmodule SecretFriend do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      {SecretFriend.Boundary.SFListsSupervisor, :noargs},
      {SecretFriend.Boundary.UserSupervisor, :noargs},
      {Registry, keys: :unique, name: SecretFriend.SFLRegistry},
      {Registry, keys: :unique, name: SecretFriend.UserRegistry}
    ]

    opts = [strategy: :one_for_one, name: SecretFriend.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
