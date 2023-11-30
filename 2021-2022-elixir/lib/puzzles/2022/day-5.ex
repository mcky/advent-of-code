defmodule AOC.Puzzles.Y2022.Day5 do
  def parse(input) do
    [stacks, moves] =
      input
      |> Enum.reject(&(&1 == ""))
      |> Enum.chunk_by(fn line ->
        String.starts_with?(line, "move")
      end)

    labelled_stacks = label_stacks(stacks)
    parsed_moves = Enum.map(moves, &parse_move/1)

    {labelled_stacks, parsed_moves}
  end

  def label_stacks(stacks) do
    {stacks2, [labels]} = Enum.split(stacks, -1)

    stacks3 =
      stacks2
      |> Enum.map(fn line ->
        line
        |> String.split("")
        |> Enum.chunk_every(4)
      end)
      |> Enum.map(fn row ->
        Enum.reject(row, fn
          [""] -> true
          _ -> false
        end)
      end)

    labels = labels |> AOC.Helpers.ints_from_string()

    Enum.map(labels, fn n ->
      Enum.map(stacks3, fn row ->
        row
        |> Enum.at(n - 1)
        |> Enum.at(2)
      end)
      |> Enum.reject(fn s -> s === " " end)
    end)
  end

  def parse_move(move_str) do
    [count, from, to] =
      Regex.scan(~r/\d+/, move_str)
      |> Enum.map(fn ints ->
        ints
        |> Enum.at(0)
        |> AOC.Helpers.safe_parse_int()
      end)

    # 0 index cols
    %{count: count, from: from - 1, to: to - 1}
  end

  def take_from_stack(stacks, count, col, :CM9000) do
    get_and_update_in(stacks, [Access.at(col)], fn stack ->
      {taken, rest} = Enum.split(stack, count)
      {Enum.reverse(taken), rest}
    end)
  end

  def take_from_stack(stacks, count, col, :CM9001) do
    get_and_update_in(stacks, [Access.at(col)], fn stack ->
      {taken, rest} = Enum.split(stack, count)
      {taken, rest}
    end)
  end

  def put_on_stack({to_put, stacks}, to) do
    update_in(stacks, [Access.at(to)], fn stack ->
      to_put ++ stack
    end)
  end

  def do_move(stacks, %{count: count, from: from, to: to}, crate_mover) do
    stacks
    |> take_from_stack(count, from, crate_mover)
    |> put_on_stack(to)
  end

  def do_moves(stacks, [move], crate_mover) do
    do_move(stacks, move, crate_mover)
  end

  def do_moves(stacks, [move | rest], crate_mover) do
    next = do_move(stacks, move, crate_mover)
    do_moves(next, rest, crate_mover)
  end

  def part_one(input) do
    {stacks, moves} = parse(input)

    do_moves(stacks, moves, :CM9000)
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.join("")
  end

  def part_two(input) do
    {stacks, moves} = parse(input)

    do_moves(stacks, moves, :CM9001)
    |> Enum.map(&Enum.at(&1, 0))
    |> Enum.join("")
  end
end
