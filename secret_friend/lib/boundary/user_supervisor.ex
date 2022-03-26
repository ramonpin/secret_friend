defmodule SecretFriend.Boundary.UserSupervisor do
  use DynamicSupervisor
  alias SecretFriend.Worker.UserWorker

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(nil) do
    :ets.new(:user_cache, [:named_table, :set, :public])
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_user(name, nick) do
    child_spec = %{id: UserWorker, start: {UserWorker, :start_link, [{name, nick}]}}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
