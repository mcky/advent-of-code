defmodule AOC.Puzzles.DaySeven do
  def parse(input) do
    input
    |> Enum.at(0)
    |> AOC.Helpers.ints_from_string(",")
  end

  def move_crab(crab_pos, end_pos) do
    abs(crab_pos - end_pos)
  end

  def triangular_numbers(n), do: trunc(n * (n + 1) / 2)

  def move_crab_expensive(crab_pos, end_pos) do
    moves = abs(crab_pos - end_pos)
    # 0..moves |> Enum.sum()
    triangular_numbers(moves)
  end

  def cost_move_all_crabs(crab_positions, end_pos, calc_crab_cost) do
    crab_positions
    |> Enum.map(&calc_crab_cost.(&1, end_pos))
    |> Enum.sum()
  end

  def bruteforce_efficient_position(input, calc_crab_cost) do
    {crab_min, crab_max} = Enum.min_max(input)

    Enum.reduce(
      crab_min..crab_max,
      {nil, nil},
      fn desired_crab_pos, {curr_pos, curr_sum} ->
        sum = cost_move_all_crabs(input, desired_crab_pos, calc_crab_cost)

        if sum < curr_sum,
          do: {desired_crab_pos, sum},
          else: {curr_pos, curr_sum}
      end
    )
  end

  def part_one(input) do
    {_move_to, _moving_cost} =
      input
      |> parse()
      |> bruteforce_efficient_position(&move_crab/2)
  end

  def part_two(input) do
    {_move_to, _moving_cost} =
      input
      |> parse()
      |> bruteforce_efficient_position(&move_crab_expensive/2)
  end
end
