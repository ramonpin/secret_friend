defmodule SecretFriend.API.SFList do
  alias SecretFriend.Worker.SFWorker

  def new(),
    do: SFWorker.start()

  def add_friend(pid, friend) do 
    send(pid, {:cast, {:add_friend, friend}})
    pid
  end

  def create_selection(pid) do
    send(pid, {:call, self(), :create_selection})
    handle_response()
  end

  def show(pid) do
    send(pid, {:call, self(), :show})
    handle_response()
  end

  defp handle_response() do
    receive do
      {:response, response} -> response
      _other -> nil
    end
  end
end
