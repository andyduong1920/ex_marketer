defmodule ExMarketer.Factory do
  use ExMachina.Ecto, repo: ExMarketer.Repo

  use ExMarketer.UserFactory
  use ExMarketer.KeywordFactory
end
