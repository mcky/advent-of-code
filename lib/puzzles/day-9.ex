defmodule AOC.Puzzles.DayNine do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string(&1, ""))
    |> to_matrix()
  end

  def to_matrix(grid) do
    indexed = grid |> Enum.map(&Enum.with_index/1) |> Enum.with_index()

    for {row, y} <- indexed do
      for {el, x} <- row do
        {{x, y}, el}
      end
    end
    |> List.flatten()
    |> Map.new()
  end

  def matrix_elem(matrix, points) do
    Map.fetch!(matrix, points)
  end

  def neighboring_coordinates(matrix, _coords = {x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.filter(&Map.has_key?(matrix, &1))
  end

  def neighboring_values(matrix, coords) do
    neighboring_coordinates(matrix, coords)
    |> Enum.map(&matrix_elem(matrix, &1))
  end

  def lower_than_neighbors?(matrix, coords) do
    value = matrix_elem(matrix, coords)

    neighboring_values(matrix, coords)
    |> Enum.all?(fn n -> value < n end)
  end

  def matrix_dimensions(matrix) do
    keys = Map.keys(matrix)

    {w, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, h} = Enum.max_by(keys, fn {_x, y} -> y end)

    {w, h}
  end

  def all_matrix_coords(matrix) do
    Map.keys(matrix)
  end

  def find_lowest(matrix) do
    matrix
    |> all_matrix_coords
    |> Enum.filter(&lower_than_neighbors?(matrix, &1))
  end

  def risk_level(matrix, lowest) do
    lowest
    |> Enum.map(fn low_point ->
      matrix_elem(matrix, low_point) + 1
    end)
    |> Enum.sum()
  end

  def matrix_diagram(matrix, coords \\ []) do
    {w, h} = matrix_dimensions(matrix)

    for y <- 0..h do
      for x <- 0..w do
        curr_coord = {x, y}
        v = matrix_elem(matrix, {x, y})

        if curr_coord in coords do
          "[#{v}]"
        else
          " #{v} "
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def print_matrix(matrix, coords \\ []) do
    IO.puts(matrix_diagram(matrix, coords))
    matrix
  end

  def start_grow_region(matrix, start_point) do
    grow_region(matrix, [start_point], MapSet.new())
    |> Enum.to_list()
  end

  def grow_region(matrix, [], seen) do
    seen
  end

  def grow_region(matrix, [start_point | rest], seen) do
    neighbors = neighboring_coordinates(matrix, start_point)

    curr_v = matrix_elem(matrix, start_point)

    valid_n =
      neighbors
      |> Enum.reject(&MapSet.member?(seen, &1))
      |> Enum.reject(fn point ->
        v = matrix_elem(matrix, point)
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
