defmodule SquishBot.Consumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api.Message

  def handle_event({:MESSAGE_CREATE, msg, _ws_state})
      when msg.author.id == 522_631_384_989_433_857 do
    case msg.content do
      "!call " <> _ ->
        Message.create(
          msg.channel_id,
          "parker is NOT allowed to use this"
        )
    end
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!eval " <> rest ->
        IO.inspect(rest)
        rest = String.trim(rest,"\n")

        {:ok, pid} = StringIO.open("hold")
        tok = Stench.Lexer.tokenize(rest)
        tree = Stench.Parser.parse(tok)
        Application.put_env(:stench, :buffer, pid)
        IO.puts(inspect(tok))
        state = Stench.CLI.eval(rest,true)
        # state = Stench.Eval.eval(tree)
        s = Tuple.to_list(StringIO.contents(pid))
        s = Enum.take(s, 1 - Enum.count(s))
        s = Enum.join(s, "\n")
        IO.puts("s: " <> s)

        {:ok, _message} =
          case state.cur_return.type do
          :bucket->
            Message.create(msg.channel_id, s <> Enum.join(Enum.map(state.cur_return.value, fn var -> var.value end),","))
          _->
            Message.create(msg.channel_id, s <> to_string(state.cur_return.value))

          end

      "!call " <> rest ->
        ary = String.split(rest, " ")

        {:ok, _message} =
          Message.create(msg.channel_id, craft_name_calling_message(ary))

      other ->
        if String.at(other, String.length(other) - 1) == "?" do
          Message.create(
            msg.channel_id,
            "Hey! <@" <>
              Integer.to_string(msg.author.id) <>
              ">! Nobody cares about your baby brain smooth brain questions. Bruh."
          )
        end
    end
  end

  def craft_name_calling_message(str_ary) when is_list(str_ary) do
    craft_name_calling_message("Hey! ", str_ary)
  end

  @type name() :: String.t()

  @spec craft_name_calling_message(string(), list()) :: string()
  def craft_name_calling_message(insult, [name | tail]) do
    insult <> name <> "! You're " <> Enum.join(tail, " ") <> ", bruh."
  end

  def handle_message("!call " <> rest) do
  end

  # Ignore any other events
  def handle_event(_), do: :ok
end
