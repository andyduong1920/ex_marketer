defmodule ExMarketer.KeywordFactory do
  import ExMarketer.AccountsFactory

  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %ExMarketer.Keyword{keyword: "grammarly", user: user_fixture()}
      end
    end
  end
end
