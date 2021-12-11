defmodule AocTest.DayEight do
  use ExUnit.Case
  doctest AOC.Puzzles.DayEight
  import AOC.Puzzles.DayEight

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(8, :simple)
    assert part_one(input) == 26
  end
end
