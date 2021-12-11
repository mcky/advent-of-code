defmodule AocTest.DayTen do
  use ExUnit.Case
  doctest AOC.Puzzles.DayTen
  import AOC.Puzzles.DayTen

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(10, :simple)
    assert part_one(input) == 26397
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(10, :simple)
    assert part_two(input) == 288_957
  end

  test "parse" do
    assert parse(["({})"]) == [["(", "{", "}", ")"]]
  end

  test "parse_expressions" do
    balanced_simple = parse_line("()")
    balanced_longer = parse_line("([{<><>}])")
    unbalanced_incomplete = parse_line("([<>")
    unbalanced_invalid = parse_line("{[(})]}")

    # balanced stack has no remainder
    assert parse_expressions(balanced_simple) == :valid
    assert parse_expressions(balanced_longer) == :valid

    # incomplete contains unclosed remainder
    assert parse_expressions(unbalanced_incomplete) == {:incomplete, ["[", "("]}

    # invalid returns the unbalanced char
    assert parse_expressions(unbalanced_invalid) == {:invalid, "}"}
  end

  test "balanced_brackets" do
    incomplete = parse_line("{{[[({([")
    expected = parse_line("}}]])})]")

    assert balanced_brackets(incomplete) === expected
  end

  test "score_incomplete_symbols" do
    incomplete_short = parse_line("])}>")
    incomplete_longer = parse_line("}}]])})]")

    assert score_incomplete_symbols(incomplete_short) == 294
    assert score_incomplete_symbols(incomplete_longer) == 288_957
  end

  test "middle_item" do
    assert middle_item(["a", "b", "c"]) == "b"
    assert middle_item([1, 2, 3, 4, 5]) == 3
    assert middle_item([1, 2, 3, 4, 5, 6, 7]) == 4
  end
end
