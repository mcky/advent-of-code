defmodule AOC.Puzzles.Y2021.DayOne do
  def parse_line(line) do
    line |> AOC.Helpers.ints_from_string() |> Enum.at(0)
  end

  def count_highest(coll) do
    {_, count} =
      Enum.reduce(coll, {nil, 0}, fn curr, {last, acc} ->
        if curr > last do
          {curr, acc + 1}
        else
          {curr, acc}
        end
      end)

    count
  end

  def day_one_p1(input) do
    input
    |> Enum.map(&parse_line/1)
    |> count_highest()
  end

  def day_one_p2(input) do
    input
    |> Enum.map(&parse_line/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> count_highest()
  end
end
