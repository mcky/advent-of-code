defmodule AocTest.Y2022.Day1 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day1
  import AOC.Puzzles.Y2022.Day1

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 1, :simple)
    assert part_one(input) == 24000
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 1)
    assert part_one(input) == 69310
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 1,:simple)
    assert part_two(input) == 45000
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 1)
    assert part_two(input) == 206104
  end
end
