defmodule AOC.Puzzles.DayNine do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string(&1, ""))
  end

  def matrix_elem(matrix, {x, y}) do
    case Enum.at(matrix, y) do
      nil -> nil
      sublist -> Enum.at(sublist, x)
    end
  end

  def neighboring_values(matrix, {x, y}) do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.map(&matrix_elem(matrix, &1))
  end

  def lower_than_neighbors?(matrix, coords) do
    value = matrix_elem(matrix, coords)

    neighboring_values(matrix, coords)
    |> Enum.to_list()
    |> Enum.all?(fn
      nil -> true
      n -> value < n
    end)
  end

  def matrix_dimensions(matrix) do
    w = Enum.at(matrix, 0) |> length()
    h = length(matrix)

    {w, h}
  end

  def all_matrix_coords(matrix) do
    {w, h} = matrix_dimensions(matrix)

    for y <- 0..(h - 1), x <- 0..(w - 1) do
      {x, y}
    end
  end

  def find_lowest(matrix) do
    all_coords = all_matrix_coords(matrix)

    Enum.reduce(all_coords, [], fn coords = {x, y}, acc ->
      if low = lower_than_neighbors?(matrix, coords) do
        [coords | acc]
      else
        acc
      end
    end)
  end

  def risk_level(matrix, lowest) do
    lowest
    |> Enum.map(fn low_point ->
      matrix_elem(matrix, low_point) + 1
    end)
    |> Enum.sum()
  end

  def part_one(input) do
    matrix =
      input
      |> parse()

    find_lowest(matrix)
    |> then(fn lowest -> risk_level(matrix, lowest) end)
  end

  def part_two(input) do
    input
    |> parse()
  end
end
