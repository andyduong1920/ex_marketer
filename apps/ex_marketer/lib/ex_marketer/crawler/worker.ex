defmodule ExMarketer.Crawler.Worker do
  use GenServer, restart: :transient

  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Parse
  alias ExMarketer.Crawler.WorkerRegistry

  # Client

  def start_link(keyword_id) do
    GenServer.start_link(__MODULE__, keyword_id, name: process_name(keyword_id))
  end

  # Server (callbacks)

  @impl true
  def init(keyword_id) do
    {:ok, %{keyword_id: keyword_id}, {:continue, :get_keyword}}
  end

  @impl true
  def handle_continue(:get_keyword, state) do
    keyword_record = find_keyword(state.keyword_id)

    {:noreply, Map.put(state, :keyword, keyword_record.keyword), {:continue, :perform}}
  end

  @impl true
  def handle_continue(:perform, state) do
    on_start(state.keyword_id)

    {:ok, response_body} = google_client().get(state.keyword)

    on_success(state.keyword_id, Parse.perform(response_body))

    {:stop, :normal, state}
  end

  @impl true
  def terminate(reason, _state) when reason in [:normal, :shutdown] do
  end

  @impl true
  def terminate({:shutdown, _term}, _state) do
  end

  def terminate(reason, state) do
    on_fail(state.keyword_id, reason)
  end

  defp google_client, do: Application.get_env(:ex_marketer, :google_client)

  defp on_start(keyword_id) do
    keyword_record = find_keyword(keyword_id)

    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().in_progress})

    broadcast_to_user(keyword_record.id, keyword_id.user_id)
  end

  defp on_success(keyword_id, result) do
    keyword_record = find_keyword(keyword_id)

    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().completed, result: Map.from_struct(result)})

    broadcast_to_user(keyword_record.id, keyword_id.user_id)
  end

  defp on_fail(keyword_id, ex) do
    # TODO: Find a way to parse the error
    # {{reason, _}, _} = ex

    keyword_record = find_keyword(keyword_id)

    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: "Failed"})

    broadcast_to_user(keyword_record.id, keyword_id.user_id)
  end

  defp broadcast_to_user(keyword_id, user_id) do
    Phoenix.PubSub.broadcast!(
      ExMarketer.PubSub,
      "user_keyword:#{user_id}",
      {:keyword_completed, %{keyword_id: keyword_id}}
    )
  end

  defp find_keyword(keyword_id) do
    Keyword.find(keyword_id)
  end

  defp process_name(keyword_id) do
    {:via, Registry, {WorkerRegistry, "crawler_#{keyword_id}"}}
  end
end
