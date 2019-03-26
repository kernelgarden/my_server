defmodule FreddieTest.Handler do
  use Freddie.Router

  require Logger

  alias FreddieTest.{Scheme, Handler, Player}

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
    {meta, context, msg}
    |> Handler.Login.handle()
  end

  connect do
    Logger.info("Client #{inspect(context)} is connected!")
  end

  disconnect do
    Logger.info("Client #{inspect(context)} is disconnected!")

    case Freddie.Context.get(context, :player_serial) do
      {:ok, player_serial} -> Player.kill(player_serial)
      _ -> :noop
    end
  end
end
