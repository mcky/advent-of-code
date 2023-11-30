defmodule AocTest.Y2022.Day4 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day4
  import AOC.Puzzles.Y2022.Day4

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 4, :simple)
    assert part_one(input) == 2
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 4)
    assert part_one(input) == 588
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 4, :simple)
    assert part_two(input) == 4
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 4)
    assert part_two(input) == 911
  end
end
