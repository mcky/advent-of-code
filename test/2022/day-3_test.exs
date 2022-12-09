defmodule AocTest.Y2022.Day3 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day3
  import AOC.Puzzles.Y2022.Day3

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 3, :simple)
    assert part_one(input) == 157
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 3)
    assert part_one(input) == 7875
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 3, :simple)
    assert part_two(input) == 70
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 3)
    assert part_two(input) == 2479
  end

  test "intersection" do
    assert intersection([
             MapSet.new([1, 2, 3]),
             MapSet.new([3, 4, 5]),
             MapSet.new([3, 6, 7])
           ]) == [3]

    assert intersection([
             MapSet.new([1, 2, 3, 9]),
             MapSet.new([2, 3, 4, 9]),
             MapSet.new([3, 5, 6, 9]),
             MapSet.new([3, 7, 8])
           ]) == [3]
  end
end
