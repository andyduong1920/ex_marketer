defmodule ExMarketer.Accounts do
  alias ExMarketer.Repo
  alias __MODULE__.Account

  def new_account(account \\ %Account{}) do
    Account.changeset(account, %{})
  end

  def register(%Ueberauth.Auth{} = params) do
    %Account{}
    |> Account.changeset(extract_account_params(params))
    |> Repo.insert()
  end

  defp extract_account_params(%{credentials: %{other: other}, info: info}) do
    info
    |> Map.from_struct()
    |> Map.merge(other)
  end
end
