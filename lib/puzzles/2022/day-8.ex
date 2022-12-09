defmodule AOC.Puzzles.Y2022.Day8 do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string(&1, ""))
    |> Matrix.new()
  end

  def directional_coords(x, y, x_max, y_max) do
    [
      (y - 1)..0,
      (x - 1)..0,
      (x + 1)..x_max,
      (y + 1)..y_max
    ]
    |> Enum.map(&Enum.to_list/1)
    |> Enum.zip([:up, :left, :right, :down])
  end

  def highest_in_direction(heights, self_height) do
    Enum.all?(heights, fn n_height -> n_height < self_height end)
  end

  def part_one(input) do
    tree_matrix = parse(input)

    {x_max, y_max} = Matrix.dimensions(tree_matrix)

    tree_matrix
    |> Matrix.map(fn
      {coord = {0, _y}, _height} ->
        {coord, true}

      {coord = {_x, 0}, _height} ->
        {coord, true}

      {coord = {^x_max, _y}, _height} ->
        {coord, true}

      {coord = {_x, ^y_max}, _height} ->
        {coord, true}

      {coord = {x, y}, height} ->
        higher =
          directional_coords(x, y, x_max, y_max)
          |> Enum.map(fn
            {coords, dir} when dir in [:left, :right] ->
              coords
              |> Enum.map(fn xc -> Matrix.at(tree_matrix, {xc, y}) end)
              |> highest_in_direction(height)

            {coords, dir} when dir in [:up, :down] ->
              coords
              |> Enum.map(fn yc -> Matrix.at(tree_matrix, {x, yc}) end)
              |> highest_in_direction(height)
          end)
          |> Enum.any?()

        {coord, higher}
    end)
    |> Map.get(:items)
    |> Enum.filter(&match?({_, true}, &1))
    |> length()
  end

  def take_while_inclusive(enumerable, fun) when is_list(enumerable) do
    Enum.reduce_while(enumerable, [], fn x, acc ->
      if apply(fun, [x]) do
        # {:cont, [x | acc]}
        {:cont, acc ++ [x]}
      else
        {:halt, acc ++ [x]}
        # {:halt, Enum.reverse([x | acc])}
      end
    end)
  end

  def take_until_blocked(heights, self_height) do
    take_while_inclusive(heights, fn heights -> heights < self_height end)
  end

  def score_view([]), do: 1

  def score_view(views), do: Enum.count(views)

  def score_views(heights) do
    heights
    |> Enum.map(&score_view/1)
    |> Enum.product()
  end

  def part_two(input) do
    tree_matrix = parse(input)

    {x_max, y_max} = Matrix.dimensions(tree_matrix)

    tree_matrix
    |> Matrix.map(fn
      {coord = {0, _y}, _height} ->
        {coord, 0}

      {coord = {_x, 0}, _height} ->
        {coord, 0}

      {coord = {^x_max, _y}, _height} ->
        {coord, 0}

      {coord = {_x, ^y_max}, _height} ->
        {coord, 0}

      {coord = {x, y}, height} ->
        score =
          directional_coords(x, y, x_max, y_max)
          |> Enum.map(fn
            {coords, dir} when dir in [:left, :right] ->
              coords
              |> Enum.map(fn xc -> Matrix.at(tree_matrix, {xc, y}) end)
              |> take_until_blocked(height)

            {coords, dir} when dir in [:up, :down] ->
              coords
              |> Enum.map(fn yc -> Matrix.at(tree_matrix, {x, yc}) end)
              |> take_until_blocked(height)
          end)
          |> score_views()

        {coord, score}
    end)
    |> Matrix.values()
    |> Enum.sort(:desc)
    |> Enum.at(0)
  end
end
