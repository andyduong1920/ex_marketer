defmodule ExMarketer.CsvParser do
  def stream_parse(file_path) do
    file_path |> File.stream!() |> CSV.decode!()
  end
end
