defmodule AOC.Puzzles.Y2022.Day6 do
  def parse(input) do
    input
    |> Enum.at(0)
    |> String.split("", trim: true)
  end

  def slice(list, start, count) when is_list(list) do
    Enum.slice(list, start, count)
  end

  def unique?(enumerable) do
    length(Enum.uniq(enumerable)) == length(enumerable)
  end

  def split(buffer, offset) do
    buffer
    |> Enum.with_index()
    |> Enum.find_value(fn {_char, i} ->
      if i >= offset do
        last_n = Enum.slice(buffer, i - offset, offset)

        if unique?(last_n) do
          i
        end
      end

      # with true <- i >= offset,
      #      last_n <- Enum.slice(buffer, i - offset, offset),
      #      true <- unique?(last_n),
      #      do: i
    end)
  end

  def part_one(input) do
    input
    |> parse()
    |> split(4)
  end

  def part_two(input) do
    input
    |> parse()
    |> split(14)
  end
end
