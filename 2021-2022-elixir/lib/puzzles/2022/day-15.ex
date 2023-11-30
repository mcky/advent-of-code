defmodule AOC.Puzzles.Y2022.Day15 do
  def parse_line(line) do
    Regex.scan(~r/[xy]=(-?\d+)/, line, capture: :all_but_first)
    |> Enum.map(&(&1 |> Enum.at(0) |> AOC.Helpers.safe_parse_int()))
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
    |> List.to_tuple()
  end

  def parse(input) do
    input
    |> Enum.map(&parse_line/1)
  end

  def print_matrix(matrix) do
    Matrix.print(matrix, fn
      {{:sensor, _}, _coord} -> "S"
      {{:beacon, _}, _coord} -> "B"
      {:fill, _coord} -> "#"
      {:not_filled, _coord} -> "."
      _ -> "?"
    end)
  end

  def manhattan_distance(_a = {a_x, a_y}, _b = {b_x, b_y}) do
    abs(a_x - b_x) + abs(a_y - b_y)
  end

  def to_matrix(sensor_coordinates) do
    sensor_coordinates
    |> Enum.flat_map(fn {sensor, beacon} ->
      [
        {sensor, {:sensor, beacon}},
        {beacon, {:beacon, sensor}}
      ]
    end)
    |> Map.new()
    |> Matrix.new()
  end

  def poly_points({x, y}, n) do
    # [left, up,right, down]
    [{x - n, y}, {x, y - n}, {x + n, y}, {x, y + n}]
  end

  def line_coords(a = {x1, y1}, b = {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    for x <- x1..x2 do
      y = y1 + dy * (x - x1) / dx
      {x, floor(y)}
    end
  end

  # @TODO: helpers, test
  # @TODO: test matrix -1 dimensions

  # @TODO: differs now from d14
  def to_pairs(list) do
    Enum.chunk_every(list, 2, 1, Enum.take(list, 1))
  end

  def poly_lines(points) do
    points
    |> to_pairs()
    |> Enum.flat_map(fn [a, b] ->
      line_coords(a, b)
    end)
  end

  def poly_lines(center_point, distance) do
    IO.puts("start poly_lines")
    bounding_box = poly_points(center_point, distance)
    IO.puts("got bounding_box")

    # {{x_min, y_min}, {_x_max, y_max}} = Matrix.minmax(bounding_box)

    IO.puts("got minmax")

    # search_y_coords =
    #   for y <- y_min..y_max do
    #     {x_min, y}
    #   end

    lines = poly_lines(bounding_box)

    IO.puts("lines done")

    lines

    # Enum.reduce(search_y_coords, [], fn {_, y}, acc ->
    #   IO.inspect(y, label: "reducing for y")

    #   {{x_min, _}, {x_max, _}} =
    #     lines
    #     |> Enum.filter(&match?({_, ^y}, &1))
    #     |> Matrix.minmax()

    #   IO.inspect(y, label: "minmax")

    #   inner = for x <- x_min..x_max, do: {x, y}

    #   IO.inspect(y, label: "inner calc'd")

    #   acc ++ inner
    # end)

    # # []
  end

  def part_one(input) do
    sensor_coordinates =
      input
      |> parse()

    with_distances =
      Enum.map(sensor_coordinates, fn {sensor, beacon} ->
        {sensor, manhattan_distance(sensor, beacon)}
      end)

    # |> IO.inspect(label: "{sensor,d}")

    # {{min_x, _}, {max_x, _}} =
    {{min_x, _}, _} =
      with_distances
      |> Enum.min_by(fn {_sensor = {x, _y}, distance} -> x - distance end)
      |> IO.inspect(label: "min_x")

    {{max_x, _}, _} =
      with_distances
      |> Enum.max_by(fn {_sensor = {x, _y}, distance} -> x + distance end)
      |> IO.inspect(label: "max_x")

    excl =
      min_x..max_x
      |> Enum.map(fn x ->
        Enum.any?(with_distances, fn {sensor, distance} ->
          manhattan_distance(sensor, {x, 2_000_000}) <= distance
        end)
      end)
      |> Enum.uniq()
      |> Enum.count()
      |> IO.inspect(label: "rng")

    num_beacons =
      sensor_coordinates
      |> Enum.map(fn {_, _beacon = {x, y}} -> {x, y} end)
      |> Enum.filter(fn {_, y} -> y == 2_000_000 end)
      |> Enum.uniq()
      |> Enum.count()
      |> IO.inspect(label: "foo")

    # shape_lines =
    #   for {sensor_coordinate, distance} <- with_distances do
    #     bounding_box = poly_points(sensor_coordinate, distance)

    #     lines =
    #       poly_lines(bounding_box)
    #       |> Enum.filter(fn {x, y} ->
    #         y == 10
    #       end)

    #     # |> IO.inspect(label: "lines")

    #     case lines do
    #       [{x_a, y}, {x_b, y}] ->
    #         for x <- x_a..x_b, do: {x, y}

    #       _ ->
    #         []
    #     end
    #   end
    #   |> List.flatten()

    # # |> IO.inspect(label: "shapelines")

    # IO.puts("calculated shape_line")

    # for x <- min_x..max_x, {x, 10} in shape_lines, reduce: 0 do
    #   n -> n+1
    # end
    # # |> length()
    # |> IO.inspect(label: "wut")

    # |> length()

    # if coord is within manhattan of one of the sensors
    # |> print_matrix()
  end

  def part_two(input) do
    input
    |> parse()
  end
end
