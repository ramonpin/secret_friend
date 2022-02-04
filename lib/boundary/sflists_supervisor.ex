defmodule SecretFriend.Boundary.SFListsSupervisor do
  use DynamicSupervisor
  alias SecretFriend.Worker.SFWorker

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_sflist(name) do
    child_spec = %{id: SFWorker, start: {SFWorker, :start_link, [name]}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
