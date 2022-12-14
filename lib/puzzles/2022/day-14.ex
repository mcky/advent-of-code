defmodule AOC.Puzzles.Y2022.Day14 do
  @moduledoc """
  Day 14: Regolith Reservoir
  """

  @sand_start {500, 0}

  def parse(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split(" -> ", trim: true)
      |> Enum.map(&AOC.Helpers.ints_from_string(&1, ","))
      |> Enum.map(&List.to_tuple/1)
    end)
  end

  def to_pairs(list) do
    Enum.chunk_every(list, 2, 1, :discard)
  end

  def expand_path_coordinates(rock_paths) do
    Enum.map(rock_paths, fn path ->
      path
      |> to_pairs()
      |> Enum.reduce([], fn [from, to], acc ->
        {from_x, from_y} = from
        {to_x, to_y} = to

        next =
          cond do
            to_y !== from_y -> from_y..to_y |> Enum.to_list() |> Enum.map(fn y -> {from_x, y} end)
            to_x !== from_x -> from_x..to_x |> Enum.to_list() |> Enum.map(fn x -> {x, from_y} end)
            true -> []
          end

        [next | acc]
      end)
    end)
    |> List.flatten()
  end

  def to_matrix(rock_paths) do
    rock_paths
    |> Enum.map(fn coord -> {coord, :rock} end)
    |> Map.new()
    |> Matrix.new()
  end

  def print_matrix(matrix) do
    Matrix.print(matrix, fn
      {_, {x, _y}} when x < 487 or x > 510 -> ""
      {:rock, _coord} -> "#"
      {:curr_sand, _coord} -> "x"
      {:sand, _coord} -> "o"
      {_, @sand_start} -> "+"
      _ -> "."
    end)
  end

  def empty?(:error), do: true
  def empty?(_), do: false

  def drop_grain_of_sand(matrix, dimensions = {max_x, max_y}, sand_coord = {x, y}) do
    down = {x, y + 1}
    left = {x - 1, y + 1}
    right = {x + 1, y + 1}

    cond do
      x < 0 or y < 0 or x > max_x or y > max_y ->
        nil

      empty?(Matrix.at(matrix, down)) ->
        drop_grain_of_sand(matrix, dimensions, down)

      {:ok, :sand} == Matrix.at(matrix, down) or
          {:ok, :rock} == Matrix.at(matrix, down) ->
        cond do
          empty?(Matrix.at(matrix, left)) ->
            drop_grain_of_sand(matrix, dimensions, left)

          empty?(Matrix.at(matrix, right)) ->
            drop_grain_of_sand(matrix, dimensions, right)

          true ->
            {Matrix.put(matrix, sand_coord, :sand), sand_coord}
        end
    end
  end

  def fill_sand(matrix, _dimensions, 999_999) do
    print_matrix(matrix)
    raise("too many iterations")
  end

  def fill_sand(matrix, dimensions, count) do
    case drop_grain_of_sand(matrix, dimensions, @sand_start) do
      {_, @sand_start} -> count + 1
      {next_matrix, _} -> fill_sand(next_matrix, dimensions, count + 1)
      nil -> count
    end
  end

  def fill_sand(matrix, dimensions) do
    fill_sand(matrix, dimensions, 0)
  end

  def part_one(input) do
    matrix =
      input
      |> parse()
      |> expand_path_coordinates()
      |> to_matrix()

    fill_sand(matrix, Matrix.dimensions(matrix))
  end

  def add_floor(matrix) do
    {max_x, max_y} = Matrix.dimensions(matrix)
    new_floor_y = max_y + 2

    # Who needs infinity when you can pad the sides
    -100..(max_x + 100)
    |> Enum.map(fn x -> {x, new_floor_y} end)
    |> Enum.reduce(matrix, fn coord, new_matrix ->
      Matrix.put(new_matrix, coord, :rock)
    end)
  end

  def part_two(input) do
    matrix =
      input
      |> parse()
      |> expand_path_coordinates()
      |> to_matrix()
      |> add_floor()

    fill_sand(matrix, Matrix.dimensions(matrix))
  end
end
