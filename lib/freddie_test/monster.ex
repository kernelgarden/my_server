defmodule FreddieTest.Monster do

  alias __MODULE__

  defstruct id: 0

  @callback init(infos :: any()) :: Monster.t()

  @callback update() :: Monster.t()

end
