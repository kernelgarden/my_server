defmodule FreddieTest.PlayerRegistry do
  @spec start_link() :: none()
  def start_link() do
    Registry.start_link(keys: :unique, name: __MODULE__, partitions: System.schedulers_online())
  end

  @spec via_tuple(integer()) :: {:via, Registry, {FreddieTest.PlayerRegistry, integer()}}
  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  @spec child_spec(any()) :: %{
          :id => any(),
          :start => {atom(), atom(), [any()]},
          optional(:modules) => :dynamic | [atom()],
          optional(:restart) => :permanent | :temporary | :transient,
          optional(:shutdown) => :brutal_kill | :infinity | non_neg_integer(),
          optional(:type) => :supervisor | :worker
        }
  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
