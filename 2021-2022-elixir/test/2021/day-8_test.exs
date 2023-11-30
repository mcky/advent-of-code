defmodule AocTest.Y2021.DayEight do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayEight
  import AOC.Puzzles.Y2021.DayEight

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2021, 8, :simple)
    assert part_one(input) == 26
  end
end
