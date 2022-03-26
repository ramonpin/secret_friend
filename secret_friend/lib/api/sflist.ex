defmodule SecretFriend.API.SFList do
  alias SecretFriend.Boundary.SFListsSupervisor
  alias SecretFriend.Worker.SFWorker

  def new(name) do
    SFListsSupervisor.create_sflist(name)
    name
  end

  def add_friend(name, friend) do
    case GenServer.call(SFWorker.via(name), {:add_friend, friend}) do
      :ok -> name
      :locked -> :locked
    end
  end

  def create_selection(name) do
    GenServer.call(SFWorker.via(name), :create_selection)
  end

  def show(name) do
    GenServer.call(SFWorker.via(name), :show)
  end

  def lock?(name) do
    GenServer.call(SFWorker.via(name), :lock?)
  end

  def lock(name) do
    GenServer.cast(SFWorker.via(name), :lock)
  end
end
