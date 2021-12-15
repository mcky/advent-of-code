defmodule AocTest.DayFourteen do
  use ExUnit.Case
  doctest AOC.Puzzles.DayFourteen
  import AOC.Puzzles.DayFourteen

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(14, :simple)
    assert part_one(input) == 1588
  end

  @tag :skip
  test "part 2 (sample)" do
    input = AOC.Setup.get_input(0, :simple)
    assert part_one(input) == nil
  end

  test "parse" do
    input = AOC.Setup.get_input(14, :simple)

    assert parse(input) == {
             "NNCB",
             %{
               "BB" => "N",
               "BC" => "B",
               "BH" => "H",
               "BN" => "B",
               "CB" => "H",
               "CC" => "N",
               "CH" => "B",
               "CN" => "C",
               "HB" => "C",
               "HC" => "B",
               "HH" => "N",
               "HN" => "C",
               "NB" => "B",
               "NC" => "B",
               "NH" => "C",
               "NN" => "C"
             }
           }
  end
end
