defmodule AOC.Puzzles.Y2021.DayEight do
  def parse(input) do
    input
    |> Enum.map(fn line ->
      [signal_patterns, output_value] = String.split(line, "|", trim: true)

      {
        String.split(signal_patterns, " ", trim: true),
        String.split(output_value, " ", trim: true)
      }
    end)
  end

  def segment_possibilities(<<_data::bytes-size(2)>>), do: [1]
  def segment_possibilities(<<_data::bytes-size(3)>>), do: [7]
  def segment_possibilities(<<_data::bytes-size(4)>>), do: [4]
  def segment_possibilities(<<_data::bytes-size(5)>>), do: [2, 3, 5]
  def segment_possibilities(<<_data::bytes-size(6)>>), do: [0, 6, 9]
  def segment_possibilities(<<_data::bytes-size(7)>>), do: [8]

  def unique_segments(segments) do
    Enum.filter(segments, fn segment ->
      case segment_possibilities(segment) do
        [_n] -> true
        _ -> false
      end
    end)
  end

  def part_one(input) do
    input
    |> parse()
    |> Enum.map(fn {_pattern, out_val} ->
      unique_segments(out_val)
      |> Enum.count()
    end)
    |> Enum.sum()
  end
end
