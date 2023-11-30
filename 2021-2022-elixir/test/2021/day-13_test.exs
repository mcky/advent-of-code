defmodule AocTest.Y2021.DayThirteen do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayThirteen
  import AOC.Puzzles.Y2021.DayThirteen

  test "part 1 (sample)" do
    sample_input = AOC.Setup.get_input(2021, 13, :simple)
    assert part_one(sample_input) == 17

    input = AOC.Setup.get_input(2021, 13)
    assert part_one(input) == 716
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2021, 13)
    assert part_one(input) == nil

    # prints RPCKFBLR
  end
end
