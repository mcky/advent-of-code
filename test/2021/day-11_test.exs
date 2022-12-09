defmodule AocTest.Y2021.DayEleven do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayEleven
  import ExUnit.CaptureIO
  import AOC.Puzzles.Y2021.DayEleven

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2021, 11, :simple)
    assert part_one(input) == 1656
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2021, 11, :simple)
    assert part_two(input) == 195
  end

  test "parse" do
    input = [
      "12",
      "45"
    ]

    assert parse(input) == %Matrix{
             items: %{
               {0, 0} => {1, false},
               {0, 1} => {4, false},
               {1, 0} => {2, false},
               {1, 1} => {5, false}
             }
           }
  end
end
