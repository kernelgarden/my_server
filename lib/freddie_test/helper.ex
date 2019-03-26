defmodule FreddieTest.Helper do

  alias FreddieTest.Scheme

  @spec make_result(boolean(), atom()) :: %{:__struct__ => atom(), optional(atom()) => any()}
  def make_result(is_success, result_code) do
    Scheme.Result.new(is_success: is_success, code: Scheme.ResultCode.value(result_code))
  end

  def make_position(x, y, z) do
    Scheme.Position.new(x: x, y: y, z: z)
  end

end
