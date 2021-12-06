defmodule AOC.Puzzles.DayFour do
  def make_unmarked_board(board) do
    board
    |> Enum.map(fn row ->
      row |> Enum.map(fn cell -> {cell, false} end)
    end)
  end

  def mark_cell({n, true}, _called), do: {n, true}

  def mark_cell({n, false}, called) do
    if called === n do
      {n, true}
    else
      {n, false}
    end
  end

  def mark_board(board, called) do
    board
    |> Enum.map(fn row ->
      row |> Enum.map(&mark_cell(&1, called))
    end)
  end

  def checked?({_n, checked}), do: checked

  def all_checked(row) do
    Enum.all?(row, &checked?/1)
  end

  def board_complete?(board) do
    row = board |> Enum.any?(&all_checked/1)
    col = board |> AOC.Helpers.transpose() |> Enum.any?(&all_checked/1)

    row || col
  end

  def mark_boards(boards, called) do
    boards |> Enum.map(fn b -> mark_board(b, called) end)
  end

  def process_d4(input) do
    [numbers_raw | boards_raw] =
      input
      |> Enum.to_list()

    numbers =
      numbers_raw
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards_raw
      |> Enum.chunk_by(fn x -> x === "\n" end)
      |> Enum.reject(fn row -> row === ["\n"] end)
      |> Enum.map(fn board ->
        board |> Enum.map(&AOC.Helpers.ints_from_string/1) |> make_unmarked_board
      end)

    {numbers, boards}
  end

  def sum_of_remainder(board) do
    board
    |> List.flatten()
    |> Enum.reject(&checked?/1)
    |> Enum.map(fn {n, _checked} -> n end)
    |> Enum.sum()
  end

  def part_one(input) do
    {numbers, init_boards} = process_d4(input)

    Enum.reduce_while(
      numbers,
      init_boards,
      fn called, boards ->
        marked = mark_boards(boards, called)

        comp =
          marked
          |> Enum.find(fn b ->
            board_complete?(b)
          end)

        unless comp do
          {:cont, marked}
        else
          {:halt, sum_of_remainder(comp) * called}
        end
      end
    )
  end

  def part_two(input) do
    {numbers, init_boards} = process_d4(input)

    init_w_pos = init_boards |> Enum.map(fn b -> {nil, nil, b} end)

    x =
      Enum.reduce(
        Enum.with_index(numbers),
        init_w_pos,
        fn {called, call_pos}, boards_indexed ->
          IO.inspect("#{called} @#{call_pos}")

          boards_indexed
          |> Enum.map(fn
            {nil, winning_call, board} ->
              marked = mark_board(board, called)

              if board_complete?(marked) do
                {call_pos, called, marked}
              else
                {nil, winning_call, marked}
              end

            {pos, win, board} ->
              {pos, win, board}
          end)
        end
      )

    [last | _rest] = x |> Enum.sort(:desc)

    {_pos, called, b} = last

    sum_of_remainder(b) * called
  end

  def part_two_v2(input) do
    {numbers, init_boards} = process_d4(input)

    init_w_pos = init_boards |> Enum.map(fn b -> {nil, nil, b} end)

    Enum.reduce_while(
      numbers,
      init_boards,
      fn called, boards ->
        marked = mark_boards(boards, called)

        comp =
          marked
          |> Enum.find(fn b ->
            board_complete?(b)
          end)

        unless comp do
          {:cont, marked}
        else
          {:halt, sum_of_remainder(comp) * called}
        end
      end
    )
  end
end
