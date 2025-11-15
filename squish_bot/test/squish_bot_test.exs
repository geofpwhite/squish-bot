defmodule SquishBotTest do
  use ExUnit.Case
  doctest SquishBot

  test "greets the world" do
    assert SquishBot.hello() == :world
  end
end
