defmodule AOC.Puzzles.Y2022.Day1 do
  def empty_line([""]), do: true
  def empty_line(""), do: true
  def empty_line(_), do: false

  def parse(input) do
    input
    |> Enum.chunk_by(&empty_line/1)
    |> Enum.reject(&empty_line/1)
    |> Enum.map(fn elf ->
      elf
      |> Enum.map(&AOC.Helpers.safe_parse_int/1)
      |> Enum.sum()
    end)
  end

  def part_one(input) do
    input
    |> parse()
    |> Enum.max()
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end
end
