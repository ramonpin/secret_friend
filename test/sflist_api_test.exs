defmodule SFList.ApiTest do
  use ExUnit.Case
  alias SecretFriend.API.SFList

  test "create new list" do
    assert SFList.new(:test) == :test

    [{test_pid, nil}] = Registry.lookup(SecretFriend.SFLRegistry, :test)
    assert test_pid != nil
  end

end
