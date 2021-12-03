defmodule SecretFriend.API.SFList do
  alias SecretFriend.Worker.SFWorker

  def new(name) do 
    SFWorker.start_link(name)
    name
  end

  def add_friend(name, friend) do 
    GenServer.cast(name, {:add_friend, friend})
    name
  end

  def create_selection(name) do
    GenServer.call(name, :create_selection)
  end

  def show(name) do
    GenServer.call(name, :show)
  end
end
