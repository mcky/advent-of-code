defmodule AocTest.Y2022.Day15 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day15
  import AOC.Puzzles.Y2022.Day15

  test "parse" do
    input = [
      "Sensor at x=2, y=18: closest beacon is at x=-2, y=15",
      "Sensor at x=9, y=16: closest beacon is at x=10, y=16"
    ]

    assert parse(input) == [
             {{2, 18}, {-2, 15}},
             {{9, 16}, {10, 16}}
           ]
  end

  test "manhattan_distance" do
    assert manhattan_distance({2, 18}, {-2, 15}) == 7
    assert manhattan_distance({9, 16}, {10, 16}) == 1
    assert manhattan_distance({8, 7}, {2, 10}) == 9
  end

  @tag :skip
  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 15, :simple)
    assert part_one(input) == 26
  end

  # @tag :skip
  test "part 1" do
    input = AOC.Setup.get_input(2022, 15)
    assert part_one(input) == nil
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 15, :simple)
    assert part_two(input) == nil
  end

  @tag :skip
  test "part 2" do
    input = AOC.Setup.get_input(2022, 15)
    assert part_two(input) == nil
  end
end
