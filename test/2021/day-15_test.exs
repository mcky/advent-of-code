defmodule AocTest.Y2021.DayFifteen do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayFifteen
  import AOC.Puzzles.Y2021.DayFifteen

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2021, 15, :simple)
    assert part_one(input) == 40
  end

  test "part 1 (real input)" do
    input = AOC.Setup.get_input(2021, 15)
    assert part_one(input) == 487
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2021, 15, :simple)
    assert part_two(input) == 315
  end

  @tag :skip
  test "part 2 (real input)" do
    # Very slow to run
    input = AOC.Setup.get_input(2021, 15)
    assert part_two(input) == 2821
  end
end
