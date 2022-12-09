defmodule AocTest.Y2022.Day8 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day8
  import AOC.Puzzles.Y2022.Day8

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 8, :simple)
    assert part_one(input) == 21
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 8)
    assert part_one(input) == 1829
  end

  test "take_while_inclusive" do
    assert take_while_inclusive([1, 2, 3, 4, 3, 4, 1], fn n -> n < 4 end) === [1, 2, 3, 4]
    assert take_while_inclusive([3, 5, 3], fn n -> n < 5 end) === [3, 5]
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 8, :simple)
    assert part_two(input) == 8
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 8)
    assert part_two(input) == 291_840
  end
end
