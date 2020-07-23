defmodule ExMarketer.Factory do
  use ExMachina.Ecto, repo: ExMarketer.Repo

  use ExMarketer.KeywordFactory
end
