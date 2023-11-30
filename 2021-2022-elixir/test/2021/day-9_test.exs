defmodule AocTest.Y2021.DayNine do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayNine
  import AOC.Puzzles.Y2021.DayNine

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2021, 9, :simple)
    assert part_one(input) == 15
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2021, 9, :simple)
    assert part_two(input) == 1134
  end

  test "find_lowest" do
    matrix =
      Matrix.new([
        [1, 2],
        [2, 1]
      ])

    assert find_lowest(matrix) == [{0, 0}, {1, 1}]
  end

  test "grow_region" do
    matrix =
      Matrix.new([
        [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
        [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
        [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
        [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
        [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      ])

    expected = [{1, 0}, {0, 0}, {0, 1}] |> Enum.sort()

    assert start_grow_region(matrix, {1, 0}) |> Enum.sort() == expected
  end
end
