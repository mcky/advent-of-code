defmodule AocTest.Matrix do
  use ExUnit.Case
  doctest Matrix
  import Integer
  import Matrix

  @simple_2x2 [
    [1, 2],
    [3, 4]
  ]

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

    input_2x2 = @simple_2x2

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

  test "from_printed" do
    # Doesn't handle sparse matrixes
    printed = """
    A B C
    D E F
    """

    assert from_printed(printed) == %Matrix{
             items: %{
               {0, 0} => "A",
               {1, 0} => "B",
               {2, 0} => "C",
               {0, 1} => "D",
               {1, 1} => "E",
               {2, 1} => "F"
             }
           }
  end

  test "at" do
    matrix = new(@simple_3x3)

    assert at(matrix, {0, 0}) == {:ok, 1}
    assert at(matrix, {2, 2}) == {:ok, 9}
    assert at(matrix, {1, 5}) == :error
    assert at(matrix, {5, 1}) == :error
    assert at(matrix, {5, 5}) == :error
  end

  test "at!" do
    matrix = new(@simple_3x3)

    assert at!(matrix, {0, 0}) == 1
    assert at!(matrix, {2, 2}) == 9

    assert_raise KeyError, fn ->
      at!(matrix, {1, 5})
    end
  end

  test "put" do
    matrix = new(@simple_2x2)

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
    matrix = new(@simple_3x3)

    assert dimensions(matrix) === {2, 2}
  end

  test "all_coords" do
    matrix = new(@simple_2x2)

    assert all_coords(matrix) === [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  end

  test "adjacent_coordinates" do
    matrix = new(@simple_3x3)

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
    matrix = new(@simple_3x3)

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

  test "fill" do
    # .  O  .
    # O  O  O
    # .  O  .
    matrix =
      new(%{
        {1, 0} => "O",
        {0, 1} => "O",
        {1, 1} => "O",
        {2, 1} => "O",
        {1, 2} => "O"
      })

    # X  O  X
    # O  O  O
    # X  O  X
    filled = fill(matrix, "X")

    assert filled == %Matrix{
             items: %{
               {0, 0} => "X",
               {1, 0} => "O",
               {2, 0} => "X",
               {0, 1} => "O",
               {1, 1} => "O",
               {2, 1} => "O",
               {0, 2} => "X",
               {1, 2} => "O",
               {2, 2} => "X"
             }
           }
  end

  test "get_repr(matrix, value_printer)" do
    matrix = new(@simple_3x3)

    printer = fn
      # @TODO: map/filter over enum order k/v differently
      {i, _} when Integer.is_odd(i) -> " X "
      {_i, _} -> " O "
    end

    assert get_repr(matrix, printer) == " X  O  X \n O  X  O \n X  O  X "
  end

  test "get_repr(matrix)" do
    matrix = new(@simple_3x3)

    assert get_repr(matrix) == " 1  2  3 \n 4  5  6 \n 7  8  9 "
  end

  test "get_repr(matrix) prints sparse matrixes" do
    matrix =
      new(%{
        {1, 1} => "#",
        {2, 2} => "#"
      })

    assert get_repr(matrix) == " #  . \n .  # "
  end

  test "get_repr(matrix, coords)" do
    matrix = new(@simple_3x3)

    assert get_repr(matrix, [{1, 0}, {2, 2}]) == " 1 [2] 3 \n 4  5  6 \n 7  8 [9]"
  end

  @tag :skip
  test "get_repr_with_labels" do
    matrix = new([["A", "B", "C"], ["D", "E", "F"], ["H", "I", "J"]])
    IO.puts("")
    IO.puts("")
    IO.puts("")
    print_with_labels(matrix)
  end

  test "map" do
    matrix =
      new([
        [1, 2, 3]
      ])

    mapped = map(matrix, fn {p, v} -> {p, v + 1} end)
    assert mapped == %Matrix{items: %{{0, 0} => 2, {1, 0} => 3, {2, 0} => 4}}
  end

  test "filter" do
    matrix = new(@simple_3x3)

    filter_fn = fn
      {_, val} when Integer.is_odd(val) -> true
      {_, _val} -> false
    end

    filtered = filter(matrix, filter_fn)

    assert filtered == %Matrix{
             items: %{
               {0, 0} => 1,
               {0, 2} => 7,
               {1, 1} => 5,
               {2, 0} => 3,
               {2, 2} => 9
             }
           }
  end

  test "find_coordinate" do
    matrix = new(@simple_3x3)

    found_coord = find_coordinate(matrix, fn {_c, value} -> value === 5 end)
    assert found_coord == {1, 1}

    found_coord = find_coordinate(matrix, fn {_c, value} -> value === "doesn't exist" end)
    assert found_coord == nil
  end

  test "values" do
    matrix = new(@simple_3x3)
    assert values(matrix) == [1, 4, 7, 2, 5, 8, 3, 6, 9]
  end
end
