defmodule AocTest.Y2022.Day2 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day2
  import AOC.Puzzles.Y2022.Day2

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 2, :simple)
    assert part_one(input) == 15
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 2, :simple)
    assert part_two(input) == 12
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 2)
    assert part_one(input) == 14264
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 2)
    assert part_two(input) == 12382
  end

  test "winning_shape" do
    assert winning_shape(:rock) == :paper
    assert winning_shape(:paper) == :scissors
    assert winning_shape(:scissors) == :rock
  end

  test "losing_shape" do
    assert losing_shape(:paper) == :rock
    assert losing_shape(:scissors) == :paper
    assert losing_shape(:rock) == :scissors
  end

  test "at_itx wraps around a list" do
    assert at_idx([1, 2, 3], 0) == 1
    assert at_idx([1, 2, 3], 3) == 1
    assert at_idx([1, 2, 3], -1) == 3
  end

  test "is_win" do
    assert is_win([:rock, :paper]) == true
    assert is_win([:rock, :rock]) == nil
    assert is_win([:paper, :rock]) == false
  end
end
