defmodule ExMarketer.Crawler.DynamicSupervisor do
  use DynamicSupervisor

  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Worker

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(max_restarts: 2, strategy: :one_for_one)
  end

  def start_chilld(keywords) when is_list(keywords) do
    keywords |> Enum.map(&start_chilld(&1))
  end

  def start_chilld(keyword) when is_binary(keyword) do
    {:ok, record} = Keyword.create(%{keyword: keyword})

    spec = {Worker, [record.id, keyword]}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
