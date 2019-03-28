defmodule FreddieTest.Monster.Supervisor do
  use Supervisor

  require Logger

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    Process.flag(:trap_exit, true)
    Supervisor.init(make_children_list(), strategy: :one_for_one)
  end

  def handle_info({:exit, from, reason}, state) do
    Logger.error(fn -> "acceptor #{inspect(from)} is down. reason: #{inspect(reason)}" end)
    {:noreply, state}
  end

  defp make_monster_group_name(idx) do
    String.to_atom("monster_group_#{idx}")
  end

  defp make_children_list do
    1..FreddieTest.MonsterRegistry.max_monster_group()
    |> Enum.map(fn idx ->
      %{
        id: make_monster_group_name(idx),
        start: {FreddieTest.Monster.Group, :start_link, [idx]},
        type: :worker,
      }
    end)
  end

end
