defmodule AocTest.Y2022.Day10 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day10
  import AOC.Puzzles.Y2022.Day10

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 10, :simple)
    assert part_one(input) == 13140
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 10)
    assert part_one(input) == 14780
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 10, :simple)

    output = [
      "##..##..##..##..##..##..##..##..##..##..",
      "###...###...###...###...###...###...###.",
      "####....####....####....####....####....",
      "#####.....#####.....#####.....#####.....",
      "######......######......######......####",
      "#######.......#######.......#######....."
    ]

    assert part_two(input) == output
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 10)

    output = [
      "####.#....###..#....####..##..####.#....",
      "#....#....#..#.#.......#.#..#....#.#....",
      "###..#....#..#.#......#..#......#..#....",
      "#....#....###..#.....#...#.##..#...#....",
      "#....#....#....#....#....#..#.#....#....",
      "####.####.#....####.####..###.####.####."
    ]

    assert part_two(input) == output
  end
end
