defmodule AocTest.Y2021.DayFourteen do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2021.DayFourteen
  import AOC.Puzzles.Y2021.DayFourteen

  test "part 1" do
    input = AOC.Setup.get_input(2021, 14, :simple)
    assert part_one(input) == 1588

    input = AOC.Setup.get_input(2021, 14)
    assert part_one(input) == 2851
  end

  @tag :skip
  test "part 2" do
    input = AOC.Setup.get_input(2021, 14, :simple)
    assert part_two(input) == 2_188_189_693_529

    input = AOC.Setup.get_input(2021, 14)
    assert part_two(input) == 10_002_813_279_337
  end

  test "do_step" do
    input = AOC.Setup.get_input(2021, 14, :simple)
    {_, rules} = parse(input)

    assert do_step(to_pair_freqs("NNCB"), rules) ==
             to_pair_freqs("NCNBCHB")

    assert do_step(to_pair_freqs("NCNBCHB"), rules) ==
             to_pair_freqs("NBCCNBBBCBHCB")

    assert do_step(to_pair_freqs("NBCCNBBBCBHCB"), rules) ==
             to_pair_freqs("NBBBCNCCNBBNBNBBCHBHHBCHB")
  end

  test "sum_frequencies" do
    pattern = "NCNBCHB"
    exp = pattern |> String.graphemes() |> Enum.frequencies()
    assert sum_frequencies(to_pair_freqs(pattern)) == exp

    pattern = "NBCCNBBBCBHCB"
    exp = pattern |> String.graphemes() |> Enum.frequencies()
    assert sum_frequencies(to_pair_freqs(pattern)) == exp

    pattern = "NBBBCNCCNBBNBNBBCHBHHBCHB"
    exp = pattern |> String.graphemes() |> Enum.frequencies()
    assert sum_frequencies(to_pair_freqs(pattern)) == exp
  end

  test "parse" do
    input = AOC.Setup.get_input(2021, 14, :simple)

    assert parse(input) == {
             %{"CB" => 1, "NC" => 1, "NN" => 1},
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
