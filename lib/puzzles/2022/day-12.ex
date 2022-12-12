defmodule AOC.Puzzles.Y2022.Day12 do
  @moduledoc """
  Day 12: Hill Climbing Algorithm
  """

  def alphabet_idx(char) do
    char
    |> String.to_charlist()
    |> hd()
    |> (&(&1 - 97 + 1)).()
  end

  def parse(input) do
    matrix =
      input
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Matrix.new()

    start_coordinate = Matrix.find_coordinate(matrix, &match?({_coord, "S"}, &1))

    end_coordinate = Matrix.find_coordinate(matrix, &match?({_coord, "E"}, &1))

    height_matrix =
      Matrix.map(matrix, fn
        {coordinate, "S"} -> {coordinate, alphabet_idx("a")}
        {coordinate, "E"} -> {coordinate, alphabet_idx("z")}
        {coordinate, char} -> {coordinate, alphabet_idx(char)}
      end)

    {start_coordinate, end_coordinate, height_matrix}
  end

  def add_to_priority_queue(q, item) do
    [item | q]
    |> Enum.sort_by(fn {_k, val, _via} -> val end, :asc)
  end

  def reconstruct_path(path = [{{0, 0}, _, _} | _rest], _visited) do
    path
  end

  def reconstruct_path(path = [head | _rest], visited) do
    {_, _, via_coords} = head

    split =
      Enum.split_with(
        visited,
        fn {coords, _, _} -> coords == via_coords end
      )

    case split do
      {[previous], visited} -> reconstruct_path([previous | path], visited)
      {[], _visited} -> path
    end
  end

  # End
  def explore(
        _matrix,
        [current = {current_coords, _, _} | _rest],
        visited,
        _visited_coords,
        end_coords
      )
      when current_coords == end_coords do
    reconstruct_path([current], visited)
  end

  # How does this case even happen. No path found?
  def explore(_matrix, [], _visited, _visited_coords, _end_coords) do
    nil
  end

  # Dijkstra's algorithm, poorly ~implemented~ copied from 2021/15
  # and hacked around even further
  # @TODO: Maintaining both visited and visited_coords is unnecessary
  def explore(matrix, [current | rest], visited, visited_coords, end_coords) do
    {curr_point, curr_val, _curr_via} = current

    val_at_point = Matrix.at(matrix, curr_point)

    visited_coords = MapSet.put(visited_coords, curr_point)

    neighbors =
      Matrix.adjacent_coordinates(matrix, curr_point)
      |> Enum.map(fn coords -> {coords, Matrix.at(matrix, coords)} end)
      |> Enum.filter(fn {_coord, value} -> value <= val_at_point + 1 end)

    {queue, visited_coords} =
      for {point, _} <- neighbors,
          !MapSet.member?(visited_coords, point),
          reduce: {rest, visited_coords} do
        {queue, visited_coords} ->
          node = {point, curr_val + 1, curr_point}

          {
            add_to_priority_queue(queue, node),
            MapSet.put(visited_coords, point)
          }
      end

    next_visited = [current | visited]

    nil
    explore(matrix, queue, next_visited, visited_coords, end_coords)
  end

  def start_search(matrix, start_coordinate, end_coordinate) do
    queue = [{start_coordinate, 1, nil}]

    explore(matrix, queue, [], MapSet.new(), end_coordinate)
  end

  def shortest_path_length(matrix, start_coordinate, end_coordinate) do
    case start_search(matrix, start_coordinate, end_coordinate) do
      path when is_list(path) -> length(path) - 1
      _ -> true
    end
  end

  def part_one(input) do
    {start_coordinate, end_coordinate, height_matrix} = parse(input)

    shortest_path_length(height_matrix, start_coordinate, end_coordinate)
  end

  def part_two(input) do
    {_start_coordinate, end_coordinate, height_matrix} = parse(input)

    starting_coordinates =
      height_matrix
      |> Matrix.items()
      |> Enum.filter(&match?({_coord, 1}, &1))

    for {start_coordinate, _} <- starting_coordinates do
      shortest_path_length(height_matrix, start_coordinate, end_coordinate)
    end
    |> Enum.min()
  end
end
