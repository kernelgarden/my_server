defmodule FreddieTest.Monster.Helper do

  alias FreddieTest.MonsterRegistry

  @doc """
  monster_id를 통해 monster group pid를 구한다.
  """
  def via_tuple(monster_id) do
    hash_key = :erlang.phash2(monster_id, MonsterRegistry.max_monster_group())
    MonsterRegistry.via_tuple(hash_key)
  end

end
