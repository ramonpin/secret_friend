defmodule SecretFriend.API.SFList do
  alias SecretFriend.Worker.SFWorker

  def new(name) do 
    SFWorker.start_link(name)
    name
  end

  def add_friend(name, friend) do 
    case GenServer.call(name, {:add_friend, friend}) do
      :ok -> name
      :locked -> :locked
    end
  end

  def create_selection(name) do
    GenServer.call(name, :create_selection)
  end

  def show(name) do
    GenServer.call(name, :show)
  end

  def lock?(name) do
    GenServer.call(name, :lock?)
  end

  def lock(name) do
    GenServer.cast(name, :lock)
  end
end
