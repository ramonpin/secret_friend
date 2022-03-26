defmodule Robot.Ops do
  def run("r" <> num), do: IO.puts("Tuerce a la derecha #{num} grados")
  def run("l" <> num), do: IO.puts("Tuerce a la izquierda #{num} grados")
  def run("f" <> num), do: IO.puts("Avanza #{num} pasos")
  def run("b" <> num), do: IO.puts("Retrocese #{num} pasos")
end
