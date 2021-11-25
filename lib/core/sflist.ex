defmodule SecretFriend.Core.SFList do
  @moduledoc """
  This module implements a secret friend list logic.
  """

  @doc """
  Creates an empty secret friend list.

      iex> sflist = SFList.new()
      []
  """
  def new, do: []

  @doc """
  Given an exisiting list this function allow us to add a new
  friend to it.

      iex> SFList.new() 
      ...>  |> SFList.add_friend(:ramon) 
      ...>  |> SFList.add_friend(:luis)
      [:luis, :ramon]
  """
  def add_friend(sflist, new_friend), do: [new_friend | sflist]

  @doc """
  Given an exisiting list this function generates a list of pairs of friends
  so the first one should give a present to the second one.

      iex> SFList.new() 
      ...>  |> SFList.add_friend(:ramon) 
      ...>  |> SFList.add_friend(:luis)
      ...>  |> SFList.add_friend(:juan)
      ...>  |> SFList.create_selection()
      [[:juan, :luis], [:luis, :ramon], [:ramon, :juan]]
  """
  def create_selection(sflist) do
    sflist
    |> Enum.shuffle()
    |> then(&Enum.chunk_every(&1, 2, 1, &1))
  end
end
