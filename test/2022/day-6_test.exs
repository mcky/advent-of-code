defmodule AocTest.Y2022.Day6 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day6
  import AOC.Puzzles.Y2022.Day6

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 6, :simple)
    assert part_one(input) == 7
    assert part_one(["bvwbjplbgvbhsrlpgdmjqwftvncz"]) == 5
    assert part_one(["nppdvjthqldpwncqszvftbrmjlhg"]) == 6
    assert part_one(["nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"]) == 10
    assert part_one(["zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"]) == 11
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 6)
    assert part_one(input) == 1582
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 6, :simple)
    assert part_two(input) == 19
    assert part_two(["mjqjpqmgbljsphdztnvjfqwrcgsmlb"]) == 19
    assert part_two(["bvwbjplbgvbhsrlpgdmjqwftvncz"]) == 23
    assert part_two(["nppdvjthqldpwncqszvftbrmjlhg"]) == 23
    assert part_two(["nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"]) == 29
    assert part_two(["zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"]) == 26
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 6)
    assert part_two(input) == 3588
  end
end
