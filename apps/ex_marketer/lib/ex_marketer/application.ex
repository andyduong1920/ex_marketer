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
      {Registry, keys: :unique, name: ExMarketer.Crawler.WorkerRegistry},
      :poolboy.child_spec(:crawler_worker_pool, poolboy_config()),
      {DynamicSupervisor,
       strategy: :one_for_one, max_restarts: 2, name: ExMarketer.DynamicSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExMarketer.Supervisor)
  end

  defp poolboy_config do
    [
      name: {:local, :crawler_worker_pool},
      worker_module: ExMarketer.Crawler.Pool,
      size: 8,
      max_overflow: 2,
      strategy: "fifo"
    ]
  end
end
