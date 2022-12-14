defmodule AocTest.Matrix do
  use ExUnit.Case
  doctest Matrix
  import Integer
  import Matrix

  @simple_3x3 [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]

  test "new (from list)" do
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

  test "new (from map)" do
    input = %{
      {0, 0} => 1,
      {1, 0} => 2
    }

    expected = %Matrix{
      items: %{
        {0, 0} => 1,
        {1, 0} => 2
      }
    }

    assert new(input) == expected
  end

  test "at" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert at(matrix, {0, 0}) == {:ok, 1}
    assert at(matrix, {2, 2}) == {:ok, 9}
    assert at(matrix, {1, 5}) == :error
    assert at(matrix, {5, 1}) == :error
    assert at(matrix, {5, 5}) == :error
  end

  test "at!" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert at!(matrix, {0, 0}) == 1
    assert at!(matrix, {2, 2}) == 9

    assert_raise KeyError, fn ->
      at!(matrix, {1, 5})
    end
  end

  test "put" do
    matrix =
      Matrix.new([
        [1, 2],
        [3, 4]
      ])

    assert put(matrix, {0, 0}, "X") == %Matrix{
             items: %{
               {0, 0} => "X",
               {1, 0} => 2,
               {0, 1} => 3,
               {1, 1} => 4
             }
           }
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

  test "all_coords" do
    matrix =
      Matrix.new([
        [1, 2],
        [3, 4]
      ])

    assert all_coords(matrix) === [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  end

  test "adjacent_coordinates" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    # gets up/down/left/right
    assert adjacent_coordinates(matrix, {1, 1}) == [
             {0, 1},
             {2, 1},
             {1, 0},
             {1, 2}
           ]

    #  doesn't wrap
    assert adjacent_coordinates(matrix, {0, 0}) == [{1, 0}, {0, 1}]
    assert adjacent_coordinates(matrix, {2, 1}) == [{1, 1}, {2, 0}, {2, 2}]
  end

  test "adjacent_coordinates (diag)" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ])

    assert all_adjacent_coordinates(matrix, {1, 1}) == [
             {0, 0},
             {2, 0},
             {0, 2},
             {2, 2},
             {0, 1},
             {2, 1},
             {1, 0},
             {1, 2}
           ]

    #  doesn't wrap
    assert all_adjacent_coordinates(matrix, {0, 0}) == [{1, 1}, {1, 0}, {0, 1}]

    assert all_adjacent_coordinates(matrix, {2, 1}) == [
             {1, 0},
             {1, 2},
             {1, 1},
             {2, 0},
             {2, 2}
           ]
  end

  test "get_repr(matrix, value_printer)" do
    matrix = new(@simple_3x3)

    printer = fn
      {i, _} when Integer.is_odd(i) -> " X "
      {_i, _} -> " O "
    end

    assert get_repr(matrix, printer) == " X  O  X \n O  X  O \n X  O  X "
  end

  test "get_repr(matrix)" do
    matrix = new(@simple_3x3)

    assert get_repr(matrix) == " 1  2  3 \n 4  5  6 \n 7  8  9 "
  end

  test "get_repr(matrix, coords)" do
    matrix = new(@simple_3x3)

    assert get_repr(matrix, [{1, 0}, {2, 2}]) == " 1 [2] 3 \n 4  5  6 \n 7  8 [9]"
  end

  test "map" do
    matrix =
      Matrix.new([
        [1, 2, 3]
      ])

    mapped = map(matrix, fn {p, v} -> {p, v + 1} end)
    assert mapped == %Matrix{items: %{{0, 0} => 2, {1, 0} => 3, {2, 0} => 4}}
  end

  test "find_coordinate" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6]
      ])

    found_coord = find_coordinate(matrix, fn {_c, value} -> value === 5 end)
    assert found_coord == {1, 1}

    found_coord = find_coordinate(matrix, fn {_c, value} -> value === "doesn't exist" end)
    assert found_coord == nil
  end

  test "values" do
    matrix =
      Matrix.new([
        [1, 2, 3],
        [4, 5, 6]
      ])

    assert values(matrix) == [1, 4, 2, 5, 3, 6]
  end
end
