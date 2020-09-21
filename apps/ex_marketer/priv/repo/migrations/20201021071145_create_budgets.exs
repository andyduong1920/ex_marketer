defmodule ExMarketer.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table("budgets") do
      add :title, :string
      add :balance, :integer

      timestamps()
    end
  end
end
