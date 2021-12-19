defmodule AOC.Puzzles.DaySeventeen do
  def parse(input) do
    s = Enum.at(input, 0)
    [x, y] = Regex.scan(~r/(x|y)=(-?\d+)..(-?\d+)/, s, capture: :all_but_first)
    [_, x1, x2] = Enum.map(x, &AOC.Helpers.safe_parse_int/1)
    [_, y1, y2] = Enum.map(y, &AOC.Helpers.safe_parse_int/1)

    {
      x1..x2,
      y1..y2
    }
  end

  def visualize({x_rng, y_rng}, trajectory) do
    y_first..y_last = y_rng
    y_rng_pos = Range.new(-y_first, -y_last)

    for y <- y_rng_pos do
      for x <- x_rng do
        {{x, y}, "T"}
      end
    end
    |> List.flatten()
    |> Map.new()
    |> Map.put({0, 0}, "S")
    |> Matrix.new()
    |> Matrix.merge(trajectory)
    |> Matrix.print()
  end

  def update_x_velocity(0), do: 0
  def update_x_velocity(n) when n > 0, do: n - 1
  def update_x_velocity(n) when n < 0, do: n + 1

  def do_step({x, y}, _velocity, {xmin..xmax, ymin..ymax}, moves, _count)
      when x in xmin..xmax and y in ymin..ymax do
    moves
  end

  # Limit to 500 iterations
  def do_step(_coordinates, _velocity, _target_ranges, _moves, 500) do
    nil
  end

  def do_step(coordinates, velocity, target_ranges, moves, count) do
    {x, y} = coordinates
    {x_velocity, y_velocity} = velocity
    {x_range, y_range} = target_ranges

    # 1. The probe's x position increases by its x velocity.
    x = x + x_velocity

    # 2. The probe's y position increases by its y velocity.
    y = y + y_velocity

    # 3. Due to drag, the probe's x velocity changes by 1 toward the value
    #    0; that is, it decreases by 1 if it is greater than 0, increases by
    #    1 if it is less than 0, or does not change if it is already 0.
    x_velocity = update_x_velocity(x_velocity)
    # 4. Due to gravity, the probe's y velocity decreases by 1.
    y_velocity = y_velocity - 1

    coordinates = {x, y}
    velocity = {x_velocity, y_velocity}

    do_step(coordinates, velocity, target_ranges, [coordinates | moves], count + 1)
  end

  def do_step(velocity, target_ranges) do
    do_step({0, 0}, velocity, target_ranges, [], 0)
  end

  def moves_to_tracjectory(moves) when is_list(moves) do
    moves
    |> Enum.map(fn {x, y} -> {{x, -y}, "#"} end)
    |> Map.new()
    |> Matrix.new()
  end

  def attempt(target_ranges, coords) do
    moves = do_step(coords, target_ranges)

    case moves do
      moves when is_list(moves) ->
        highest =
          moves
          |> Enum.map(&elem(&1, 1))
          |> Enum.max()

        highest

      moves ->
        nil
    end
  end

  def part_one(input) do
    target_ranges = parse(input)

    for x <- 0..100 do
      for y <- 0..100 do
        highest = attempt(target_ranges, {x, y})
        {{x, y}, highest}
      end
    end
    |> List.flatten()
    |> Enum.reject(&match?({_, nil}, &1))
    |> Enum.max_by(fn {c, h} -> h end)
  end

  def part_two(input) do
    input
    |> parse()
  end
end
