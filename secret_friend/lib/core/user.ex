defmodule SecretFriend.Core.User do
  def new(name, nick) do
    %{name: name, nick: nick, sflists: []}
  end

  def sflists(%{sflists: sflists} = _user), do: sflists

  def add_sflist(%{sflists: sflists} = user, new_sflist) do
    %{user | sflists: [new_sflist | sflists]}
  end
end
