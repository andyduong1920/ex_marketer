defmodule ExMarketer.Keyword do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias ExMarketer.Keyword
  alias ExMarketer.Repo
  alias ExMarketer.Accounts.User

  @statues %{
    created: "created",
    in_progress: "in_progress",
    successed: "successed",
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
    # TODO: Pagination
    query =
      from(Keyword,
        order_by: [desc: :inserted_at],
        limit: 20
      )

    Repo.all(query)
  end

  def list_by_user(user_id) do
    # TODO: Pagination
    query =
      from(k in Keyword,
        where: k.user_id == ^user_id,
        order_by: [desc: :inserted_at],
        limit: 20
      )

    Repo.all(query)
  end

  def find(id) do
    Repo.get(Keyword, id)
  end

  def create(attrs \\ %{}) do
    %Keyword{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update!(%Keyword{} = keyword, attrs \\ %{}) do
    keyword
    |> update_changeset(attrs)
    |> Repo.update!()
  end

  def successed?(keyword) do
    keyword.status === "successed"
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
end
