defmodule ExMarketer.Repo.Migrations.MigrateData do
  use Ecto.Migration

  import Ecto.Query, only: [from: 2]

  alias ExMarketer.Repo
  alias ExMarketer.Keyword

  def change do
    query = from(k in Keyword, where: k.status == "successed")

    Repo.update_all(query, set: [status: "completed"])
  end
end
