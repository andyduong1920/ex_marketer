defmodule ExMarketer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExMarketer.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExMarketer.PubSub},
      {Oban, oban_config()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExMarketer.Supervisor)
  end

  defp oban_config do
    Application.get_env(:ex_marketer, Oban)
  end
end
