defmodule ExMarketer.Budget do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias ExMarketer.Budget
  alias ExMarketer.Repo

  schema "budgets" do
    field(:title, :string)
    field(:balance, :integer)

    timestamps()
  end

  def changeset(%Budget{} = budget, attrs) do
    budget
    |> cast(attrs, [:title, :balance])
    |> validate_required([:title, :balance])
  end

  def create(attrs \\ %{}) do
    %Budget{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(budget, attrs \\ %{}) do
    budget
    |> changeset(attrs)
    |> Repo.update()
  end

  def find_by_title(title) do
    Repo.get_by(Budget, title: title)
  end

  def find_by_title_and_lock(title) do
    from(b in Budget,
      where: b.title == ^title,
      lock: "FOR UPDATE"
    ) |> Repo.one
  end

  def find_by_title_and_nowait_lock(title) do
    from(b in Budget,
      where: b.title == ^title,
      lock: "FOR UPDATE NOWAIT"
    ) |> Repo.one
  end

  # Demo

  def reset_balance() do
    budget = Budget.find_by_title("WFH")

    Budget.update(budget, %{balance: 100})
  end

  def example_job(id) do
    IO.puts("--------------")
    IO.puts("Started job #{id}")

    :timer.sleep(3000)

    IO.puts("Finished job #{id}")
  end

  def non_concurrency() do
    example_job(1)
    example_job(2)
  end

  def intro_concurrency() do
    Task.async_stream([1, 2, 3, 4], fn job_id ->
      example_job(job_id)
    end)
    |> Stream.run()
  end

  def demo_1 do
    update_balance(10)
  end

  def demo_2 do
    Task.async_stream([10, 20, 30, 40], fn amount ->
      update_balance(amount)
    end)
    |> Stream.run()
  end

  def demo_3 do
    Task.async_stream([10, 20, 30, 40], fn amount ->
      update_balance_lock(amount)
    end)
    |> Stream.run()
  end

  def demo_4 do
    Task.async_stream([10, 20, 30, 40], fn amount ->
      update_balance_nowait_lock(amount)
    end)
    |> Stream.run()
  end

  def update_balance(amount) do
    Repo.transaction fn ->
      IO.puts("--------------")
      IO.puts("Started update transaction for #{amount}")

      budget = Budget.find_by_title("WFH")
      Budget.update(budget, %{balance: budget.balance - amount})
    end
  end

  def update_balance_lock(amount) do
    Repo.transaction fn ->
      IO.puts("--------------")
      IO.puts("Started update transaction for #{amount}")

      budget = Budget.find_by_title_and_lock("WFH")
      Budget.update(budget, %{balance: budget.balance - amount})
    end
  end

  def update_balance_nowait_lock(amount) do
    Repo.transaction fn ->
      IO.puts("--------------")
      IO.puts("Started update transaction for #{amount}")

      budget = Budget.find_by_title_and_nowait_lock("WFH")
      Budget.update(budget, %{balance: budget.balance - amount})
    end
  end
end
