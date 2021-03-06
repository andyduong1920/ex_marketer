defmodule ExMarketerWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExMarketerWeb.Telemetry,
      # Start the Endpoint (http/https)
      ExMarketerWeb.Endpoint,
      ExMarketerWeb.Presence
      # Start a worker by calling: ExMarketerWeb.Worker.start_link(arg)
      # {ExMarketerWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExMarketerWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExMarketerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
