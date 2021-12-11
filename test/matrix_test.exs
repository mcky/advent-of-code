defmodule AocTest.Matrix do
  use ExUnit.Case
  doctest Matrix
  import Matrix

  test "new" do
    input_1x2 = [[1, 2]]

    expected_1x2 = %Matrix{
      items: %{
        {0, 0} => 1,
        {1, 0} => 2
      }
    }

    input_2x2 = [
      [1, 2],
      [3, 4]
    ]

    expected_2x2 = %Matrix{
      items: %{
        {0, 0} => 1,
        {1, 0} => 2,
        {0, 1} => 3,
        {1, 1} => 4
      }
    }

    assert new(input_1x2) == expected_1x2
    assert new(input_2x2) == expected_2x2
  end

  test "at" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert at(matrix, {0, 0}) == 1
    assert at(matrix, {2, 2}) == 9
    # assert at(matrix, {1, 5}) == :error
    # assert at(matrix, {5, 1}) == :error
    # assert at(matrix, {5, 5}) == :error
  end

  test "dimensions" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert dimensions(matrix) === {2, 2}
  end

  test "neighboring_coordinates" do
    matrix =
      Matrix.new([
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

  test "get_repr" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6]
      ])

    assert get_repr(matrix) == " 1  2  3 \n 4  5  6 "
    assert get_repr(matrix, [{1, 0}]) == " 1 [2] 3 \n 4  5  6 "
  end
end
