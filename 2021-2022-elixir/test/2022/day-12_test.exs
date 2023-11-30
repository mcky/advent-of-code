defmodule AocTest.Y2022.Day12 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day12
  import AOC.Puzzles.Y2022.Day12

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 12, :simple)
    assert part_one(input) == 32
  end

  test "part 1 (sample 2)" do
    input = [
      "SEzyxwv",
      "apqrstu",
      "bonmlkj",
      "cdefghi"
    ]

    assert part_one(input) == 27
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 12)
    assert part_one(input) == 481
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 12, :simple)
    assert part_two(input) == 29
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 12)
    assert part_two(input) == 480
  end
end
