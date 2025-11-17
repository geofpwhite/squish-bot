defmodule SquishBot.Consumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api.Message


  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
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

  def craft_name_calling_message(str_ary) do
    craft_name_calling_message("Hey! ", str_ary)
  end

  def craft_name_calling_message(insult, [name | tail]) do
    insult <> name <> "! You're " <> Enum.join(tail, " ") <> ", bruh."
  end

  # Ignore any other events
  def handle_event(_), do: :ok
end
