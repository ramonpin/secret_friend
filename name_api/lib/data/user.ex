defmodule NameApi.Data.User do
  @enforce_keys [:name]

  @type age :: non_neg_integer

  @type t :: %__MODULE__{name: String.t(), type: String.t(), age: age()}
  defstruct name: nil, type: "Persona", age: 0

  alias NameApi.Data.User

  @spec happy_birthday(User.t()) :: User.t()
  def happy_birthday(%User{age: age} = user) do
    %{user | age: age + 1}
  end
end
