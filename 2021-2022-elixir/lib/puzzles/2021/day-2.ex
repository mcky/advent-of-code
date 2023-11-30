defmodule AOC.Puzzles.Y2021.DayTwo do
  def parse_line(line) do
    [dir, n] = AOC.Helpers.ints_from_string(line)
    {dir, n}
  end

  def sum_directions(dirs) do
    # Enum.reduce(dirs, {0, 0}, fn
    #   {"forward", n}, {x, y} -> {x + n, y}
    #   {"up", n}, {x, y} -> {x, y - n}
    #   {"down", n}, {x, y} -> {x, y + n}
    # end)

    Enum.reduce(dirs, {0, 0}, fn command, {x, y} ->
      case command do
        {"forward", n} -> {x + n, y}
        {"up", n} -> {x, y - n}
        {"down", n} -> {x, y + n}
        _ -> {x, y}
      end
    end)
  end

  def sum_directions_p2(dirs) do
    Enum.reduce(dirs, {0, 0, 0}, fn command, {x, y, aim} ->
      case command do
        {"forward", n} -> {x + n, y + n * aim, aim}
        {"up", n} -> {x, y, aim - n}
        {"down", n} -> {x, y, aim + n}
        _ -> {x, y, aim}
      end
    end)
  end

  def part_one(input) do
    input
    |> Enum.map(&parse_line/1)
    |> sum_directions
    |> then(fn {x, y} -> x * y end)
  end

  def part_two(input) do
    input
    |> Enum.map(&parse_line/1)
    |> sum_directions_p2
    |> then(fn {x, y, _} -> x * y end)
  end
end
