defmodule TestingvampireTest do
  use ExUnit.Case
  doctest Testingvampire

  test "greets the world" do
    assert Testingvampire.hello() == :world
  end
end
