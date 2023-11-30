defmodule AocTest.Y2022.Day9 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day9
  import AOC.Puzzles.Y2022.Day9

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 9, :simple)
    assert part_one(input) == 13
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 9)
    assert part_one(input) == 6212
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 9, :simple)
    assert part_two(input) == 1
  end

  test "part 2 (extended sample)" do
    input = [
      "R 5",
      "U 8",
      "L 8",
      "D 3",
      "R 17",
      "D 10",
      "L 25",
      "U 20"
    ]

    assert part_two(input) == 36
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 9)
    assert part_two(input) == 2522
  end
end
