defmodule AOC.Puzzles.Y2021.DayNine do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string(&1, ""))
    |> Matrix.new()
  end

  def lower_than_neighbors?(matrix, coords) do
    value = Matrix.at!(matrix, coords)

    Matrix.adjacent_values(matrix, coords)
    |> Enum.all?(fn n -> value < n end)
  end

  def find_lowest(matrix) do
    matrix
    |> Matrix.all_coords()
    |> Enum.filter(&lower_than_neighbors?(matrix, &1))
  end

  def risk_level(matrix, lowest) do
    lowest
    |> Enum.map(fn low_point ->
      Matrix.at!(matrix, low_point) + 1
    end)
    |> Enum.sum()
  end

  def start_grow_region(matrix, start_point) do
    grow_region(matrix, [start_point], MapSet.new())
    |> Enum.to_list()
  end

  def grow_region(_matrix, [], seen) do
    seen
  end

  def grow_region(matrix, [start_point | rest], seen) do
    neighbors = Matrix.adjacent_coordinates(matrix, start_point)

    curr_v = Matrix.at!(matrix, start_point)

    valid_n =
      neighbors
      |> Enum.reject(&MapSet.member?(seen, &1))
      |> Enum.reject(fn point ->
        v = Matrix.at!(matrix, point)
        v > curr_v and v >= 9
      end)

    now_seen = MapSet.put(seen, start_point)
    grow_region(matrix, rest ++ valid_n, now_seen)
  end

  def biggest_basins(basins) do
    basins
    |> Enum.map(&length/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.product()
  end

  def part_one(input) do
    matrix = parse(input)

    lowest = find_lowest(matrix)
    risk_level(matrix, lowest)
  end

  def part_two(input) do
    matrix =
      input
      |> parse()

    matrix
    |> find_lowest()
    |> Enum.map(&start_grow_region(matrix, &1))
    |> biggest_basins()
  end
end
