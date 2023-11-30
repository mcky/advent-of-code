defmodule AocTest.Y2022.Day13 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day13
  import AOC.Puzzles.Y2022.Day13

  @tag :skip
  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 13, :simple)
    assert part_one(input) == 13
  end

  # @tag :skip
  test "pair_ordered?" do
    IO.inspect("---- one ----")
    assert pair_ordered?([1, 1, 3, 1, 1], [1, 1, 5, 1, 1]) === true
    IO.inspect("---- two ----")
    assert pair_ordered?([[1], [2, 3, 4]], [[1], 4]) === true
    IO.inspect("---- three ----")
    assert pair_ordered?([9], [[8, 7, 6]]) === false
    IO.inspect("---- four ----")
    assert pair_ordered?([[4, 4], 4, 4], [[4, 4], 4, 4, 4]) === true
    IO.inspect("---- five ----")
    assert pair_ordered?([7, 7, 7, 7], [7, 7, 7]) === false
    IO.inspect("---- six ----")
    assert pair_ordered?([], [3]) === true
    IO.inspect("---- seven ----")
    assert pair_ordered?([[[]]], [[]]) === false
    IO.inspect("---- eight ----")

    assert pair_ordered?([1, [2, [3, [4, [5, 6, 7]]]], 8, 9], [1, [2, [3, [4, [5, 6, 0]]]], 8, 9]) ===
             false

    # assert pair_ordered?(
    #          [[10, [3, 10, 3, 6, [6, 6]], [7, []], 6]],
    #          [[], [6, 1, []]]
    #        ) === false

    # assert pair_ordered?(
    #          [],
    #          [[[9, 7], [7, 9, [8, 7, 6, 0, 0]]]]
    #        ) === true

    # assert pair_ordered?(
    #   [[1,1],2],
    #   [[1,1],1]
    #        ) === false


    # IO.inspect("---- node ----")
    # IO.inspect("node example 1")

    assert pair_ordered?(
      [[],[],[[[3,6,6,1,5],9],[[7,2],[],[9,2,4],[7,8,10,0,3]],4,[[6,9,5,2]]],[6,6,[[4,10]]]],
      [[],[6]]
           ) == true
    # assert pair_ordered?(
    #          [[[6, 10], [4, 3, [4]]]],
    #          [[4, 3, [[4, 9, 9, 7]]]]
    #        ) == true

    # IO.inspect("node example 2")

    # assert pair_ordered?([[6, [[3, 10], [], [], 2, 10], [[6, 8, 4, 2]]], []], [
    #          [6, [], [2, [6, 2], 5]]
    #        ]) == true

    # IO.inspect("node example 3")

    # assert pair_ordered?([[4, [], 0], [], [1, [2, [3]], 8, 5], [], [10]], [
    #          [[9, [10, 2]], [5, [8, 6], 6, 4, [9, 10]], 10],
    #          [6, 9, [[10, 1]]],
    #          [],
    #          [[[6, 6, 6, 8, 8], 3], [6, []], [[0, 5, 5, 10], 4, 1, [3, 3]], 8]
    #        ]) == false

    # IO.inspect("node example 4")

    # assert pair_ordered?(
    #          [
    #            [
    #              [[5, 3], 1, [10, 2, 9, 7, 3]],
    #              [[9, 1, 1], [10]],
    #              [[1, 6, 3, 10], 7, [2], 4, 1],
    #              0,
    #              5
    #            ],
    #            [[[10, 1, 3, 7, 1], [8, 8, 8, 0, 9], 1], [8, [1, 1, 10, 7]], [[]]],
    #            []
    #          ],
    #          [[], [[[7], [], [9, 5], 5, [9, 7, 8, 9]]], [3, 6, [7, []]], [6, 9]]
    #        ) == true

    # IO.inspect("node example 5")

    # assert pair_ordered?(
    #          [[[[9, 8, 6]], [[10, 6, 8, 2, 0]], 8, 3, 3], [[], [[0, 4, 1], 1, [], 4, []]], []],
    #          [[3, [[9, 1, 8, 9]], 6], []]
    #        ) == true

    # IO.inspect("node example 6")

    # assert pair_ordered?([[0, 3, [1, [], 3, [6, 7, 0]], [2, 0, [8, 8, 0, 5, 2], 8]], []], [
    #          [7, 5],
    #          [[[6, 6, 1]], 5, 9, 1, 4],
    #          [[[8, 8, 8], 1], 9, [[4, 9], 3, 2, 0, [0, 4]]]
    #        ]) == false

    # IO.inspect("node example 7")

    # assert pair_ordered?(
    #          [
    #            [4, []],
    #            [4, [[9, 4, 7]], 1, [[3], [4, 6, 8], [8, 8, 9]], 8],
    #            [[[4], 9, [0, 1, 4]], [[10, 6, 2], 10, 8, 0, [1, 3, 1, 3, 8]]],
    #            [[3, [6, 3, 10, 10], []], [7], 2],
    #            [10, 9, 2, 0, 7]
    #          ],
    #          [
    #            [9, 0, [[], 6, [4], 2, 9], 2],
    #            [[[6, 2, 10, 1, 7], [10], [], 9], [[3, 5, 6, 2, 6]], 7],
    #            [3, [[7, 6], 9]],
    #            [[[2, 0, 9, 2], 3, [10, 4, 7, 9], [3]], 4, [], [[6, 2], 5, 0, 5, 4]]
    #          ]
    #        ) == false

    # IO.inspect("node example 8")

    # assert pair_ordered?([[[2, [2, 9]]], [[], [[3, 9, 1, 1, 3]], 6, 6, []]], [
    #          [0, 6, [[8, 8, 4, 8, 10], 9]],
    #          [3, [7, 9, 6, [5]], [7, 5, [5]], 8, 9]
    #        ]) == true

    # IO.inspect("node example 9")

    # assert pair_ordered?(
    #          [
    #            [5, 2, [[], 4, [], [4, 10, 1, 10], 10], 3, [[0, 7, 5, 2, 0], 4, [5, 5, 5, 0]]],
    #            [
    #              [[2, 6, 4], 8],
    #              [6, 3, [8, 10, 1, 5], 9, [9, 7]],
    #              8,
    #              [8, 5, 1, 4, 1],
    #              [[0, 3, 2, 2]]
    #            ]
    #          ],
    #          [[10], [2, [2], [8, [3, 3], 6], 8], [[[0, 9, 5, 9, 5]], 2, 6]]
    #        ) == false

    # IO.inspect("node example 10")

    # assert pair_ordered?(
    #          [
    #            [[], [[3, 4, 4], [1, 10, 10, 0, 7], [10, 5, 5], [2, 6, 0, 0]], 7, 2, 5],
    #            [8, [[5, 0, 6]], 1, 10, [4, [7, 3, 6], [3, 10, 5], 4, [4, 2, 5, 9]]],
    #            [],
    #            [8, 7, 0, [7, [2, 5, 5], 10, 8, 9]],
    #            [[[0], 10, 1, [7]], 10, 7]
    #          ],
    #          [
    #            [],
    #            [
    #              [[7, 4, 1, 1], [], 5, 10],
    #              [8, [9, 1, 4, 6, 5], [3, 7, 5, 2, 8], 0],
    #              [[4], 10, [5, 5, 6, 8], [3, 2, 7]],
    #              4
    #            ]
    #          ]
    #        ) == true
  end

  # @tag :skip
  test "part 1" do
    input = AOC.Setup.get_input(2022, 13)
    assert part_one(input) == 19570
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 13, :simple)
    assert part_two(input) == nil
  end

  @tag :skip
  test "part 2" do
    input = AOC.Setup.get_input(2022, 13)
    assert part_two(input) == nil
  end
end
