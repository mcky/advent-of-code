defmodule AocTest.DayThirteen do
  use ExUnit.Case
  doctest AOC.Puzzles.DayThirteen
  import AOC.Puzzles.DayThirteen

  test "part 1 (sample)" do
    sample_input = AOC.Setup.get_input(13, :simple)
    assert part_one(sample_input) == 17

    input = AOC.Setup.get_input(13)
    assert part_one(input) == 716
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(13)
    assert part_one(input) == nil

    # prints RPCKFBLR
  end
end
