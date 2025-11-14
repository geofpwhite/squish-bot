defmodule SquishBot do
  use Application

  def start(_type, _args) do
    bot_options = %{
      consumer: ExampleConsumer,
      intents: [:direct_messages, :guild_messages, :message_content],
      wrapped_token: fn -> System.fetch_env!("BOT_TOKEN") end
    }

    children = [{Nostrum.Bot, bot_options}]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end

defmodule consumer do
  @behaviour Nostrum.Consumer

  alias Nostrum.Api.Message

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "ping!" ->
        Message.create(msg.channel_id, "I copy and pasted this code")

      _ ->
        :ignore
    end
  end
end
