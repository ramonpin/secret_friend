defmodule SecretFriend.API.User do
  alias SecretFriend.Worker.UserWorker
  alias SecretFriend.API.SFList

  def new(name, nick) do
    UserWorker.start_link({name, nick})
  end

  def sflists(nick) do
    GenServer.call(nick, :sflists)
  end

  def add_me_to(nick, sflist) do
    GenServer.cast(nick, {:add_me_to, sflist})
  end

  def secret_friend(nick, sflist_name) do
    sflist_name
    |> SFList.create_selection()
    |> find_in_selection(nick)
  end

  def secret_friends(nick) do
    nick
    |> sflists()
    |> Enum.map(&{&1, secret_friend(nick, &1)})
  end

  defp find_in_selection(selection, nick) do
    case Enum.find(selection, fn [pair_nick, _] -> pair_nick == nick end) do
      nil -> nil
      [^nick, name] -> name
    end
  end
end
