defmodule ExMarketer.KeywordFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %ExMarketer.Keyword{keyword: "grammarly"}
      end
    end
  end
end
