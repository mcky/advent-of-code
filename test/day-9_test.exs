defmodule AocTest do
  use ExUnit.Case
  doctest AOC.Puzzles.DayNine
  import AOC.Puzzles.DayNine

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(9, :simple)
    assert part_one(input) == 15
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(9, :simple)
    assert part_two(input) == 1134
  end

  test "find_lowest" do
    matrix =
      to_matrix([
        [1, 2],
        [2, 1]
      ])

    assert find_lowest(matrix) == [{0, 0}, {1, 1}]
  end

  test "to_matrix" do
    matrix = [
      [1, 2],
      [3, 4]
    ]

    assert to_matrix([[1, 2]]) == %{
             {0, 0} => 1,
             {1, 0} => 2
           }

    assert to_matrix(matrix) == %{
             {0, 0} => 1,
             {1, 0} => 2,
             {0, 1} => 3,
             {1, 1} => 4
           }
  end

  test "matrix_elem" do
    matrix =
      to_matrix([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert matrix_elem(matrix, {0, 0}) == 1
    assert matrix_elem(matrix, {2, 2}) == 9
    # assert matrix_elem(matrix, {1, 5}) == :error
    # assert matrix_elem(matrix, {5, 1}) == :error
    # assert matrix_elem(matrix, {5, 5}) == :error
  end

  test "grow_region" do
    matrix =
      to_matrix([
        [2, 1, 9, 9, 9, 4, 3, 2, 1, 0],
        [3, 9, 8, 7, 8, 9, 4, 9, 2, 1],
        [9, 8, 5, 6, 7, 8, 9, 8, 9, 2],
        [8, 7, 6, 7, 8, 9, 6, 7, 8, 9],
        [9, 8, 9, 9, 9, 6, 5, 6, 7, 8]
      ])

    assert start_grow_region(matrix, {1, 0}) |> Enum.sort() ==
             [{1, 0}, {0, 0}, {0, 1}] |> Enum.sort()
  end

  test "matrix_dimensions" do
    matrix =
      to_matrix([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert matrix_dimensions(matrix) === {2, 2}
  end

  test "neighboring_coordinates" do
    matrix =
      to_matrix([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    # gets up/down/left/right
    assert neighboring_coordinates(matrix, {1, 1}) == [
             {0, 1},
             {2, 1},
             {1, 0},
             {1, 2}
           ]

    #  doesn't wrap
    assert neighboring_coordinates(matrix, {0, 0}) == [{1, 0}, {0, 1}]
    assert neighboring_coordinates(matrix, {2, 1}) == [{1, 1}, {2, 0}, {2, 2}]
  end

  test "matrix_diagram" do
    matrix =
      to_matrix([
        [1, 2, 3],
        [4, 5, 6]
      ])

    assert matrix_diagram(matrix) == " 1  2  3 \n 4  5  6 "
    assert matrix_diagram(matrix, [{1, 0}]) == " 1 [2] 3 \n 4  5  6 "
  end
end
