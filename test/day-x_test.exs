defmodule AocTest.DayTemplate do
  use ExUnit.Case
  doctest AOC.Puzzles.DayTemplate
  import AOC.Puzzles.DayTemplate

  @tag :skip
  test "part 1 (sample)" do
    input = AOC.Setup.get_input(0, :simple)
    assert part_one(input) == nil
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(0, :simple)
    assert part_one(input) == nil
  end
end
