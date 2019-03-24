defmodule FreddieTest.Handler do
  use Freddie.Router

  require Logger

  alias FreddieTest.{Scheme, Hanlder, Player}

  defhandler FreddieTest.Scheme.CS_Echo do
    echo = Scheme.SC_Echo.new(msg: msg.msg)
    Freddie.Session.send(context, echo)
  end

  defhandler FreddieTest.Scheme.CS_EncryptPing do
    case meta.use_encryption do
      true ->
        IO.puts("Received encrypt ping from client. msg: #{inspect(msg.msg)} - #{msg.idx}")

      false ->
        IO.puts("Received ping from client. msg: #{inspect(msg.msg)} - #{msg.idx}")
    end

    pong = Scheme.SC_EncryptPong.new(msg: "Pong!", idx: msg.idx + 1)
    Freddie.Session.send(context, pong, use_encryption: true)
  end

  defhandler FreddieTest.Scheme.CS_Login do
    {context, msg}
    |> Handler.Login.handle()
  end

  connect do
    Logger.info("Client #{inspect(context)} is connected!")

    new_serial_id = FreddieTest.LocalSerialGenerator.new()

    Player.Supervisor.start_child(new_serial_id)

    Freddie.Context.put(context, :player_serial, new_serial_id)
  end

  disconnect do
    Logger.info("Client #{inspect(context)} is disconnected!")

    context
    |> Freddie.Context.get(:player_serial)
    |> Player.kill()
  end
end
