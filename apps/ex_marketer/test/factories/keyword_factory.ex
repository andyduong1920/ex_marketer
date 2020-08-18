defmodule ExMarketer.KeywordFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %ExMarketer.Keyword{keyword: "grammarly", user: build(:user)}
      end
    end
  end
end
