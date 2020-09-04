defmodule ExMarketer.Keyword do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Ecto.Multi
  alias ExMarketer.Keyword
  alias ExMarketer.Repo
  alias ExMarketer.Accounts.User
  alias ExMarketer.Worker.Crawler

  @statues %{
    created: "created",
    in_progress: "in_progress",
    completed: "completed",
    failed: "failed"
  }

  schema "keywords" do
    field(:keyword, :string)
    field(:status, :string, default: @statues.created)
    field(:result, :map, default: %{})
    field(:failure_reason, :string)
    field(:file, :map, virtual: true)

    belongs_to(:user, User)

    timestamps()
  end

  def statues() do
    @statues
  end

  def all() do
    Repo.all(all_query())
  end

  def list_by_user(user_id) do
    # TODO: Pagination
    query =
      from(k in all_by_user_query(user_id),
        order_by: [desc: :inserted_at],
        limit: 20
      )

    Repo.all(query)
  end

  def search_by_keyword_name(keyword_name, user_id) do
    query =
      from(k in all_by_user_query(user_id),
        where: ilike(k.keyword, ^"#{keyword_name}%"),
        order_by: [desc: :inserted_at],
        limit: 10
      )

    Repo.all(query)
  end

  def in_progress_keyword_stats(user_id) do
    query =
      from(k in all_by_user_query(user_id),
        select: %{
          record_count: count(k.id)
        },
        where: k.status == ^"in_progress"
      )

    [%{record_count: record_count}] = Repo.all(query)

    record_count
  end

  def find(id) do
    Repo.get(Keyword, id)
  end

  def create(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:keyword, changeset(%Keyword{}, attrs))
    |> Multi.run(:job, fn _repo, %{keyword: keyword} ->
      %{keyword_id: keyword.id, keyword: keyword.keyword}
      |> Crawler.new()
      |> Oban.insert()
    end)
    |> Repo.transaction()
  end

  def update!(%Keyword{} = keyword, attrs \\ %{}) do
    keyword
    |> update_changeset(attrs)
    |> Repo.update!()
  end

  def completed?(keyword) do
    keyword.status === "completed"
  end

  def changeset(%Keyword{} = keyword, attrs) do
    keyword
    |> cast(attrs, [:keyword, :status, :result, :failure_reason, :user_id])
    |> validate_required([:keyword, :user_id])
    |> validate_inclusion(:status, Map.values(@statues))
    |> assoc_constraint(:user)
  end

  def update_changeset(keyword, attrs) do
    keyword
    |> cast(attrs, [:status, :result, :failure_reason])
    |> validate_inclusion(:status, Map.values(@statues))
  end

  def upload_keyword_changeset(attrs \\ %{}) do
    %Keyword{}
    |> cast(attrs, [:file])
    |> validate_required(:file)
  end

  defp all_query() do
    from(Keyword, order_by: [desc: :inserted_at])
  end

  defp all_by_user_query(user_id) do
    from(k in Keyword, where: k.user_id == ^user_id)
  end
end
