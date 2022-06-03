defmodule Paths do
  defmodule Path do
    defstruct path: [], last: nil, visited: MapSet.new()

    def add(%Path{} = path, node) do
      %Path{
        path: [node | path.path],
        last: node,
        visited: MapSet.put(path.visited, node)
      }
    end
  end

  @doc """
  Given a file with caves data returns a caves map.
  """
  def data(file) do
    file
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "-"))
    |> Stream.flat_map(fn [a, b] -> [{a, b}, {b, a}] end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  def calc_paths(caves) do
    path = Path.add(%Path{}, "start")
    calc_paths(caves, [], [path])
  end

  def calc_paths(caves, explored, running) do
    {explored, running} =
      for rpath <- running,
          adjacent <- caves[rpath.last],
          valid?(rpath, adjacent),
          new_rpath = Path.add(rpath, adjacent),
          reduce: {explored, []} do
        {e, r} ->
          case adjacent do
            "end" -> {[Enum.reverse(new_rpath.path) | e], r}
            _node -> {e, [new_rpath | r]}
          end
      end

    if running == [] do
      explored
    else
      calc_paths(caves, explored, running)
    end
  end

  defp valid?(path, node) do
    cond do
      String.upcase(node) == node -> true
      node not in path.visited -> true
      true -> false
    end
  end
end
