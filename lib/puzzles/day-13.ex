defmodule AOC.Puzzles.DayThirteen do
  def parse(input) do
    {coordinates, folds} =
      input
      |> Enum.reject(fn l -> String.trim(l) == "" end)
      |> Enum.split_while(&String.contains?(&1, ","))

    coordinates =
      coordinates
      |> Enum.map(&AOC.Helpers.ints_from_string(&1, ","))
      |> Enum.map(fn [x, y] ->
        {{x, y}, "#"}
      end)
      |> Map.new()
      |> Matrix.new()

    folds =
      folds
      |> Enum.map(fn l ->
        [axis, n] = Regex.run(~r/(x|y)=(\d+)/, l, capture: :all_but_first)

        {
          axis,
          AOC.Helpers.safe_parse_int(n)
        }
      end)

    {coordinates, folds}
  end

  def fold_on_axis(matrix, {"y", fold_pos}) do
    Matrix.map(matrix, fn
      {{x, y}, v} when y > fold_pos ->
        new_y = fold_pos - (y - fold_pos)
        {{x, new_y}, v}

      point ->
        point
    end)
  end

  def fold_on_axis(matrix, {"x", fold_pos}) do
    Matrix.map(matrix, fn
      {{x, y}, v} when x > fold_pos ->
        new_x = fold_pos - (x - fold_pos)
        {{new_x, y}, v}

      point ->
        point
    end)
  end

  def do_folds(matrix, []) do
    matrix
  end

  def do_folds(matrix, [fold | rest]) do
    next = fold_on_axis(matrix, fold)
    do_folds(next, rest)
  end

  def part_one(input) do
    {coordinates, folds} =
      input
      |> parse()

    folds = folds |> Enum.take(1)

    coordinates
    |> do_folds(folds)
    |> Matrix.count()
  end

  def part_two(input) do
    {coordinates, folds} =
      input
      |> parse()

    coordinates
    |> do_folds(folds)
    |> Matrix.print()
  end
end
