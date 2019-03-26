defmodule FreddieTest.Handler.Login do

  alias FreddieTest.Repo
  alias FreddieTest.Helper
  alias FreddieTest.Model.User

  def handle({_meta, context, msg}) do
    user =
      # 편의상 로그인과 가입을 겸해서 사용한다.
      case FreddieTest.Repo.get_by(User, player_name: msg.player_name) do
        nil ->
          # 생성
          result =
            %User{}
            |> User.changeset(Map.merge(%{player_name: msg.player_name, password: msg.password}, User.default_attrs()))
            |> Repo.insert()

          case result do
            {:ok, stored_user} -> stored_user
            {:error, _} -> nil
          end

        stored_user ->
          stored_user
      end


    # 일단은 실패하는 경우가 없다.

    position = Helper.make_position(user.current_pos_x, user.current_pos_y, user.current_pos_z)

    response =
      FreddieTest.Scheme.SC_Login.new(
        id: user.id,
        player_name: user.player_name,
        player_pos: position
      )
      |> IO.inspect(label: "[Debug] => User login: ")

    # 원활한 테스트를 위해서 로그인과 동시에 인게임으로 들어오게 한다.
    new_serial_id = FreddieTest.LocalSerialGenerator.new()
    FreddieTest.Player.Supervisor.start_child(new_serial_id)

    # session에서 바로 식별 가능하도록 session context에 player serial id 를 등록한다.
    Freddie.Context.put(context, :player_serial, new_serial_id)

    Freddie.Session.send(context, response)
  end
end
