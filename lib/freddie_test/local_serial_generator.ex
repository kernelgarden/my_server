defmodule FreddieTest.LocalSerialGenerator do
  use Agent

  @spec start_link(any()) :: {:error, any()} | {:ok, pid()}
  def start_link(_args) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @spec new() :: integer()
  def new() do
    Agent.get_and_update(__MODULE__, fn cur_id -> {cur_id, cur_id + 1} end)
  end
end
