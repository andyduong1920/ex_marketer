defmodule ExMarketer.CsvParserTest do
  use ExUnit.Case, async: true

  alias ExMarketer.CsvParser

  test "stream_parse/1 returns a Stream" do
    file_path = "test/fixture/template.csv"

    assert is_struct(CsvParser.stream_parse(file_path))
  end
end
