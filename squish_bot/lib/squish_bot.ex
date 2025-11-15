defmodule SquishBot do
  @moduledoc """
  Documentation for `SquishBot`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SquishBot.hello()
      :world

  """
  def hello do
    key = Application.get_env(:nostrum,:token)
    IO.puts(key)
  end
end
