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

  # Just a demonstrate for handle_continue, it run before the perform
  @impl true
  def handle_continue(:get_keyword, state) do
    keyword_record = Keyword.find(state.keyword_id)

    new_state =
      state
      |> Map.put(:keyword_record, keyword_record)
      |> Map.put(:keyword, keyword_record.keyword)
      |> Map.put(:user_id, keyword_record.user_id)

    {:noreply, new_state, {:continue, :perform}}
  end

  @impl true
  def handle_continue(:perform, state) do
    on_start(state.keyword_record)

    {:ok, response_body} = google_client().get(state.keyword)

    on_success(state.keyword_record, Parse.perform(response_body))

    {:stop, :normal, state}
  end

  @impl true
  def terminate(reason, _state) when reason in [:normal, :shutdown] do
  end

  @impl true
  def terminate({:shutdown, _term}, _state) do
  end

  def terminate(reason, state) do
    on_fail(state.keyword_record, reason)
  end

  defp google_client, do: Application.get_env(:ex_marketer, :google_client)

  defp on_start(keyword_record) do
    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().in_progress})

    broadcast_to_user(keyword_record)
  end

  defp on_success(keyword_record, result) do
    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().completed, result: Map.from_struct(result)})

    broadcast_to_user(keyword_record)
  end

  defp on_fail(keyword_record, ex) do
    {{reason, _}, _} = ex

    keyword_record
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: Atom.to_string(reason)})

    broadcast_to_user(keyword_record)
  end

  defp broadcast_to_user(keyword_record) do
    Phoenix.PubSub.broadcast!(
      ExMarketer.PubSub,
      "user_keyword:#{keyword_record.user_id}",
      {:keyword_completed, %{keyword_id: keyword_record.id}}
    )
  end

  defp process_name(keyword_id) do
    {:via, Registry, {WorkerRegistry, "crawler_#{keyword_id}"}}
  end
end
