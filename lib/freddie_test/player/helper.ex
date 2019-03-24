defmodule FreddieTest.Player.Helper do
  @spec via_tuple(integer()) :: {:via, Registry, {FreddieTest.PlayerRegistry, integer()}}
  def via_tuple(player_serial) do
    FreddieTest.PlayerRegistry.via_tuple(player_serial)
  end
end
