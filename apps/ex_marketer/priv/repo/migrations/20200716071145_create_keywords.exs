defmodule ExMarketer.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table("keywords") do
      add :keyword, :string
      add :status, :string
      add :result, :jsonb
      add :failure_reason, {:array, :string}, default: []

      timestamps()
    end
  end
end
