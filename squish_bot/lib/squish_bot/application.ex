defmodule SquishBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    bot_options = %{
      name: SquishBot,
      consumer: SquishBot.Consumer,
      intents: [:direct_messages,:guild_messages, :message_content],
      wrapped_token: fn -> Application.get_env(:squish_bot,:BOT_TOKEN) end,
      dev: true
    }
    IO.puts(Application.get_env(:squish_bot,:BOT_TOKEN))

    children = [
      {Nostrum.Bot, bot_options}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SquishBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
