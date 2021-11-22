defmodule SecretFriend.Worker.SFWorker do
  alias SecretFriend.Core.SFList

  def start() do
    spawn(SecretFriend.Worker.SFWorker, :loop, [SFList.new(), nil])
  end

  def loop(sflist, selection) do
    receive do
      {:add_friend, :tadeo} ->
        loop(sflist, selection)

      {:add_friend, friend} ->
        sflist = SFList.add_friend(sflist, friend)
        loop(sflist, nil)

      {:create_selection, from} ->
        case selection do
          nil ->
            new_selection = SFList.create_selection(sflist)
            send(from, {:reply_create_selection, new_selection})
            loop(sflist, new_selection)

          existing_selection ->
            send(from, {:reply_create_selection, existing_selection})
            loop(sflist, existing_selection)
        end

      {:show, from} ->
        send(from, {:reply_show, sflist})
        loop(sflist, selection)
    end
  end

  def add_friend(pid, friend),
    do: send(pid, {:add_friend, friend})

  def create_selection(pid) do
    send(pid, {:create_selection, self()})

    receive do
      {:reply_create_selection, selection} ->
        selection

      _other ->
        nil
    end
  end

  def show(pid) do
    send(pid, {:show, self()})

    receive do
      {:reply_show, sflist} ->
        sflist

      _other ->
        nil
    end
  end
end
