defmodule AocTest.Y2021.DaySeventeen do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DaySeventeen
  import AOC.Puzzles.Y2021.DaySeventeen

  test "part 1" do
    input = AOC.Setup.get_input(2021, 17, :simple)
    assert part_one(input) == {{6, 9}, 45}

    input = AOC.Setup.get_input(2021, 17)
    assert part_one(input) == {{22, 77}, 3003}
  end

  @tag :skip
  test "part 2" do
    input = AOC.Setup.get_input(2021, 17, :simple)
    assert part_two(input) == nil
  end
end
