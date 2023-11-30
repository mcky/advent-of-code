defmodule AocTest.Y2021.DayTemplate do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayTemplate
  import AOC.Puzzles.Y2021.DayTemplate

  @tag :skip
  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2021, 0, :simple)
    assert part_one(input) == nil
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2021, 0, :simple)
    assert part_one(input) == nil
  end
end
