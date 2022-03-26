defmodule NameApi.Meta.MyFramework do
  defmacro __using__(opts) do
    quote do
      alias NameApi.Data.User, as: APIUser
      import NameApi.Meta.MyFramework

      import NameApi.Data.User, only: [happy_birthday: 1]
      require NameApi.Meta.MyFramework

      def name() do
        "My name is #{unquote(Keyword.get(opts, :name, "Unknown"))}"
      end
    end
  end

  defmacro mi_prima([name: name, value: value]) do
    quote do
      def unquote(name), do: unquote(value)
    end
  end
end
