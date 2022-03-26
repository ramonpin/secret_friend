defmodule Pepe do
  use NameApi.Meta.MyFramework, name: __MODULE__ 

  def run() do
    happy_birthday(%APIUser{name: "Ramon"})
  end

  mi_prima(name: time, value: "10:00:00")
  mi_prima(name: module, value: __MODULE__)
end
