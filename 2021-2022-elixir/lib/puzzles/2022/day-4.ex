defmodule AOC.Puzzles.Y2022.Day4 do
  def parse(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(fn pair ->
        pair
        |> AOC.Helpers.ints_from_string("-")
        |> range_from_pair()
        |> range_to_map()
      end)
    end)
  end

  def range_from_pair([a, b]), do: a..b

  def range_to_map(range) do
    range
    |> Enum.to_list()
    |> MapSet.new()
  end

  def part_one(input) do
    input
    |> parse()
    |> Enum.filter(fn [a, b] ->
      MapSet.subset?(a, b) || MapSet.subset?(b, a)
    end)
    |> length()
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.reject(fn [a, b] ->
      MapSet.disjoint?(a, b)
    end)
    |> length()
  end
end
