defmodule AocTest.Y2022.Day14 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day14
  import AOC.Puzzles.Y2022.Day14

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 14, :simple)
    assert part_one(input) == 24
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 14)
    assert part_one(input) == 1330
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 14, :simple)
    assert part_two(input) == 93
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 14)
    assert part_two(input) == 26139
  end
end
