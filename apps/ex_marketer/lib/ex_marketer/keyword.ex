defmodule ExMarketer.Keyword do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExMarketer.Keyword
  alias ExMarketer.Repo

  @statues %{
    created: "created",
    in_progress: "in_progress",
    successed: "successed",
    failed: "failed"
  }

  schema "keywords" do
    field :keyword, :string
    field :status, :string, default: @statues.created
    field :result, :map, default: %{}
    field :failure_reason, {:array, :string}, default: []

    timestamps()
  end

  def statues() do
    @statues
  end

  def changeset(%Keyword{} = keyword, attrs \\ %{}) do
    keyword
    |> cast(attrs, [:keyword, :status, :result, :failure_reason])
    |> validate_required(:keyword)
    |> validate_inclusion(:status, Map.values(@statues))
  end

  def find(id) do
    Repo.get(Keyword, id)
  end

  def create(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Keyword{} = keyword, attrs \\ %{}) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end
end
