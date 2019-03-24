defmodule FreddieTest.Player do
  use GenServer

  alias __MODULE__

  defstruct serial_id: 0

  @spec start_link(integer()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(serial_id) do
    GenServer.start_link(__MODULE__, serial_id, name: Player.Helper.via_tuple(serial_id))
  end

  @spec kill(integer()) :: :ok
  def kill(serial_id) do
    GenServer.cast(Player.Helper.via_tuple(serial_id), :kill)
  end

  @spec init(any()) :: {:ok, FreddieTest.Player.t()}
  def init(serial_id) do
    {:ok, %Player{serial_id: serial_id}}
  end

  def handle_cast(:kill, state) do
    {:stop, :normal, state}
  end

  def handle_info(_unknown_msg, state) do
    {:noreply, state}
  end
end
