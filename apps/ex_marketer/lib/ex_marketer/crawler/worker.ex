defmodule ExMarketer.Crawler.Worker do
  use GenServer, restart: :transient

  alias ExMarketer.Keyword
  alias ExMarketer.Crawler.Parse
  alias ExMarketer.Crawler.WorkerRegistry

  # Client

  def start_link(keyword_id) do
    GenServer.start_link(__MODULE__, keyword_id, name: process_name(keyword_id))
  end

  def perform(keyword_id) do
    GenServer.cast(process_name(keyword_id), :perform)
  end

  # Server (callbacks)

  @impl true
  def init(keyword_id) do
    {:ok, %{keyword_id: keyword_id}, {:continue, :get_keyword}}
  end

  # Just a demonstrate for handle_continue
  @impl true
  def handle_continue(:get_keyword, state) do
    keyword_record = find_keyword(state.keyword_id)

    new_state =
      state
      |> Map.put(:keyword, keyword_record.keyword)
      |> Map.put(:user_id, keyword_record.user_id)

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:perform, state) do
    on_start(state.keyword_id)

    {:ok, response_body} = google_client().get(state.keyword)

    on_success(state.keyword_id, Parse.perform(response_body))

    {:stop, :normal, state}
  end

  @impl true
  def terminate(reason, state) when reason in [:normal, :shutdown] do
    broadcast_to_user(state.user_id, state.keyword_id)
  end

  @impl true
  def terminate({:shutdown, _term}, state) do
    broadcast_to_user(state.user_id, state.keyword_id)
  end

  def terminate(reason, state) do
    on_fail(state.keyword_id, reason)

    broadcast_to_user(state.user_id, state.keyword_id)
  end

  defp google_client, do: Application.get_env(:ex_marketer, :google_client)

  defp on_start(keyword_id) do
    keyword_id
    |> find_keyword
    |> Keyword.update!(%{status: Keyword.statues().in_progress})
  end

  defp on_success(keyword_id, result) do
    keyword = find_keyword(keyword_id)

    keyword
    |> Keyword.update!(%{status: Keyword.statues().completed, result: Map.from_struct(result)})
  end

  defp on_fail(keyword_id, ex) do
    %MatchError{term: {:error, error_message}} = ex

    keyword = find_keyword(keyword_id)

    keyword
    |> Keyword.update!(%{status: Keyword.statues().failed, failure_reason: error_message})

    :error
  end

  defp find_keyword(keyword_id) do
    Keyword.find(keyword_id)
  end

  defp broadcast_to_user(user_id, keyword_id) do
    Phoenix.PubSub.broadcast!(
      ExMarketer.PubSub,
      "user_keyword:#{user_id}",
      {:keyword_completed, %{keyword_id: keyword_id}}
    )
  end

  defp process_name(keyword_id) do
    {:via, Registry, {WorkerRegistry, "crawler_#{keyword_id}"}}
  end
end
