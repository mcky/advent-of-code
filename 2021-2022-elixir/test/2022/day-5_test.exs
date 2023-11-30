defmodule AocTest.Y2022.Day5 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day5
  import AOC.Puzzles.Y2022.Day5

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 5, :simple)
    assert part_one(input) == "CMZ"
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 5)
    assert part_one(input) == "TQRFCBSJJ"
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 5, :simple)
    assert part_two(input) == "MCD"
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 5)
    assert part_two(input) == "RMHFJNVFP"
  end
end
