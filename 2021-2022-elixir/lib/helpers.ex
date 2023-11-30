defmodule AOC.Helpers do
  def safe_parse_int(string) do
    case Integer.parse(string) do
      {n, _rem} -> n
      :error -> string
    end
  end

  def ints_from_string(string, split_on \\ " ") do
    string
    |> String.split(split_on, trim: true)
    |> Enum.map(&safe_parse_int/1)
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
