defmodule AOC.Puzzles.Y2021.DayFifteen do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string(&1, ""))
    |> Matrix.new()
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

    {[previous], visited} =
      Enum.split_with(
        visited,
        fn {coords, _, _} -> coords == via_coords end
      )

    reconstruct_path([previous | path], visited)
  end

  # End
  def explore(
        _graph,
        [current = {current_coords, _, _} | _rest],
        visited,
        _visited_coords,
        end_coords
      )
      when current_coords == end_coords do
    reconstruct_path([current], visited)
  end

  # Dijkstra's algorithm, poorly implemented
  # @TODO: Maintaining both visited and visited_coords is uneccessary
  def explore(matrix, [current | rest], visited, visited_coords, end_coords) do
    {curr_point, curr_val, _curr_via} = current

    visited_coords = MapSet.put(visited_coords, curr_point)

    neighbors =
      Matrix.adjacent_coordinates(matrix, curr_point)
      |> Enum.map(fn coords -> {coords, Matrix.at(matrix, coords)} end)

    {queue, visited_coords} =
      for {point, v} <- neighbors,
          !MapSet.member?(visited_coords, point),
          reduce: {rest, visited_coords} do
        {queue, visited_coords} ->
          node = {point, curr_val + v, curr_point}

          {
            add_to_priority_queue(queue, node),
            MapSet.put(visited_coords, point)
          }
      end

    next_visited = [current | visited]

    explore(matrix, queue, next_visited, visited_coords, end_coords)
  end

  def start_search(matrix) do
    start_coordinate = {0, 0}
    end_coordinate = Matrix.dimensions(matrix)
    queue = [{start_coordinate, 1, nil}]

    explore(matrix, queue, [], MapSet.new(), end_coordinate)
  end

  def shortest_path_in_matrix(matrix) do
    chain = start_search(matrix)
    [_first | rest] = chain |> Enum.map(&elem(&1, 0))

    rest
    |> Enum.map(fn coord -> Matrix.at(matrix, coord) end)
    |> Enum.sum()
  end

  defp wrap(n) when n > 9, do: rem(n, 9)
  defp wrap(n), do: n

  defp expand_matrix(matrix) do
    {w, h} = Matrix.dimensions(matrix)

    lengthways =
      for mult_x <- 0..4, reduce: matrix do
        acc_x ->
          x_offset = w * mult_x + mult_x

          next =
            Matrix.map(matrix, fn {{x, y}, v} ->
              {{x + x_offset, y}, wrap(v + mult_x)}
            end)

          Matrix.merge(acc_x, next)
      end

    vertical =
      for mult_y <- 0..4, reduce: matrix do
        acc_y ->
          y_offset = h * mult_y + mult_y

          next =
            Matrix.map(lengthways, fn {{x, y}, v} ->
              {{x, y + y_offset}, wrap(v + mult_y)}
            end)

          Matrix.merge(acc_y, next)
      end

    vertical
  end

  def part_one(input) do
    input
    |> parse()
    |> shortest_path_in_matrix()
  end

  def part_two(input) do
    input
    |> parse()
    |> expand_matrix()
    |> shortest_path_in_matrix()
  end
end
