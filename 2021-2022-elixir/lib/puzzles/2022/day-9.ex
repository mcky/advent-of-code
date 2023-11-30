defmodule AOC.Puzzles.Y2022.Day9 do
  def parse(input) do
    input
    |> Enum.map(&AOC.Helpers.ints_from_string/1)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.flat_map(&split_move/1)
  end

  def split_move(_move = {dir, n}) do
    List.duplicate(dir, n)
  end

  def adjacent?(point, b) do
    Matrix.all_adjacent_coordinates(point)
    |> Enum.member?(b)
  end

  def parallel?({x, _a_y}, {x, _b_y}), do: true
  def parallel?({_a_x, y}, {_b_x, y}), do: true
  def parallel?(_a, _b), do: false

  def move_tail_parallel({x, head_y}, {x, tail_y}) do
    if head_y > tail_y do
      {x, tail_y + 1}
    else
      {x, tail_y - 1}
    end
  end

  def move_tail_parallel({head_x, y}, {tail_x, y}) do
    if head_x > tail_x do
      {tail_x + 1, y}
    else
      {tail_x - 1, y}
    end
  end

  def move_tail_diagonal(head, tail) do
    Matrix.diagonal_coordinates(tail)
    |> Enum.find(fn new_possibility ->
      adjacent?(head, new_possibility)
    end)
  end

  def calc_tail(tail_coord, head_coord) do
    cond do
      # in fact, the head (H) and tail (T) must always be touching
      # (diagonally adjacent and even overlapping both count as touching):
      tail_coord == head_coord -> tail_coord
      adjacent?(tail_coord, head_coord) -> tail_coord
      #
      # If the head is ever two steps directly up, down, left, or right
      # from the tail, the tail must also move one step in
      # that direction so it remains close enough
      parallel?(tail_coord, head_coord) -> move_tail_parallel(head_coord, tail_coord)
      #
      # Otherwise, if the head and tail aren't touching and aren't in the same
      # row or column, the tail always moves one step diagonally to keep up:
      # tail_coord
      true -> move_tail_diagonal(head_coord, tail_coord)
    end
  end

  def do_step(_initial_coord = {x, y}, _move = "R"), do: {x + 1, y}
  def do_step(_initial_coord = {x, y}, _move = "L"), do: {x - 1, y}
  def do_step(_initial_coord = {x, y}, _move = "U"), do: {x, y - 1}
  def do_step(_initial_coord = {x, y}, _move = "D"), do: {x, y + 1}

  def do_move(rope, dir) do
    next_rope =
      rope
      |> Enum.with_index()
      |> Enum.reduce([], fn {segment, i}, acc2 ->
        case i do
          0 ->
            n = do_step(segment, dir)
            [n | acc2]

          _ ->
            prev_segment = Enum.at(acc2, 0)
            n = calc_tail(segment, prev_segment)
            [n | acc2]
        end
      end)

    next_rope =
      next_rope
      |> Enum.reverse()

    tails1 = [Enum.at(next_rope, -1)]

    {next_rope, tails1}
  end

  def do_moves(rope, [move | rest_moves], tail_positions) do
    {next_rope, tails} = do_move(rope, move)

    do_moves(next_rope, rest_moves, tails ++ tail_positions)
  end

  def do_moves(_rope, [], tail_positions) do
    tail_positions
  end

  def run(moves, knots) do
    List.duplicate({0, 0}, knots)
    |> do_moves(moves, [])
    |> Enum.uniq()
  end

  def part_one(input) do
    input
    |> parse()
    |> run(2)
    |> length()
  end

  def part_two(input) do
    input
    |> parse()
    |> run(10)
    |> length()
  end
end
