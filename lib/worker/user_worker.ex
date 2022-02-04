defmodule SecretFriend.Worker.UserWorker do
  use GenServer
  alias SecretFriend.Core.User

  def start_link({_name, nick} = user_args) when is_atom(nick) do
    GenServer.start_link(__MODULE__, user_args, name: nick)
  end

  @impl GenServer
  def init({name, nick}) do
    case :ets.lookup(:user_cache, nick) do
      [] ->
        new_user = User.new(name, nick)
        :ets.insert(:user_cache, {nick, new_user})

        {:ok, new_user}

      [{^nick, user}] ->
        {:ok, user}
    end
  end

  @impl GenServer
  def handle_call(:info, _from, %{name: name, nick: nick} = user) do
    {:reply, {name, nick}, user}
  end

  @impl GenServer
  def handle_call(:sflists, _from, %{sflists: sflists} = user) do
    {:reply, sflists, user}
  end

  @impl GenServer
  def handle_cast({:add_me_to, sflist_name}, %{nick: nick, sflists: sflists} = user) do
    case SecretFriend.API.SFList.add_friend(sflist_name, nick) do
      :locked ->
        {:noreply, user}

      name ->
        new_user = %{user | sflists: [name | sflists]}
        :ets.insert(:user_cache, {nick, new_user})

        {:noreply, new_user}
    end
  end
end
