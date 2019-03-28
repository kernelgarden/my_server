defmodule FreddieTest.Monster.Group do
  use GenServer

  alias __MODULE__
  alias FreddieTest.MonsterRegistry
  alias FreddieTest.Monster.Helper

  @update_tick 50

  defstruct group_id: 0,
            monster_map: %{}

  def start_link(group_id) do
    GenServer.start_link(__MODULE__, group_id, name: MonsterRegistry.via_tuple(group_id))
  end

  def register_monster(monster_id, monster_info) do
    GenServer.call(Helper.via_tuple(monster_id), {:register_monster, monster_id, monster_info})
  end

  def remove_monster(monster_id) do
    GenServer.call(Helper.via_tuple(monster_id), {:remove_monster, monster_id})
  end

  @impl true
  def init(group_id) do

    Process.send_after(self(), {:update}, @update_tick)

    {:ok, %Group{group_id: group_id}}
  end

  @impl true
  def handle_call({:register_monster, monster_id, monster_info}, _from, state) do
    new_state = %Group{state | monster_map: Map.put_new(state.monster_map, monster_id, monster_info)}
    IO.puts("Monster Group [#{state.group_id}] - register #{monster_id}")
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_call({:remove_monster, monster_id}, _from, state) do
    new_state = %Group{state | monster_map: Map.delete(state.monster_map, monster_id)}
    IO.puts("Monster Group [#{state.group_id}] - remove #{monster_id}")
    {:reply, :ok, new_state}
  end

  @impl true
  def handle_info({:update}, state) do
    #IO.puts("Monster Group [#{state.group_id}] - update!")

    Process.send_after(self(), {:update}, @update_tick)
    {:noreply, state}
  end

  @impl true
  def handle_info(_unknown_msg, state) do
    {:noreply, state}
  end

end
