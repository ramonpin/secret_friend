defmodule Submarine do
  defstruct pos: 0, depth: 0

  def forward(%Submarine{} = submarine, n) when is_integer(n),
    do: %{submarine | pos: submarine.pos + n}

  def up(%Submarine{} = submarine, n) when is_integer(n),
    do: %{submarine | depth: submarine.depth - n}

  def down(%Submarine{} = submarine, n) when is_integer(n),
    do: %{submarine | depth: submarine.depth + n}
end

defmodule Dive do
  def program(file) do
    File.stream!(file, mode: :line)
    |> Stream.map(&String.trim/1)
  end

  def run(file) do
    file
    |> program()
    |> Enum.reduce(%Submarine{}, &command/2)
  end

  def command("forward " <> n, sub) do
    case Integer.parse(n) do
      {n, ""} -> Submarine.forward(sub, n)
      _otherwise -> raise "Parse error 'forward #{n}'"
    end
  end

  def command("up " <> n, sub) do
    case Integer.parse(n) do
      {n, ""} -> Submarine.up(sub, n)
      _otherwise -> raise "Parse error 'up #{n}'"
    end
  end

  def command("down " <> n, sub) do
    case Integer.parse(n) do
      {n, ""} -> Submarine.down(sub, n)
      _otherwise -> raise "Parse error 'down #{n}'"
    end
  end
end
