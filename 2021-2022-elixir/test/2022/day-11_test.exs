defmodule AocTest.Y2022.Day11 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day11
  import AOC.Puzzles.Y2022.Day11

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 11, :simple)
    assert part_one(input) == 10605
  end

  test "parse_monkey" do
    monkey_text = """
    Monkey 0:
      Starting items: 63, 84, 80, 83, 84, 53, 88, 72
      Operation: new = old * 11
      Test: divisible by 13
        If true: throw to monkey 4
        If false: throw to monkey 7
    """

    assert parse_monkey(monkey_text) == %{
             monkey_n: 0,
             starting_items: [63, 84, 80, 83, 84, 53, 88, 72],
             operation: "old * 11",
             divisible_by: 13,
             next_monkey_true: 4,
             next_monkey_false: 7,
             inspect_count: 0
           }
  end

  @tag :skip
  test "do_turn" do
    turns = [
      %{
        "monkey_n" => 0,
        # item 1 becomes 10 then 3, goes to monkey 2
        # item 2 becomes 20 then 6, goes to monkey 1
        "starting_items" => [1, 2],
        "operation" => "old * 10",
        "test" => "divisible by 2",
        "next_monkey_true" => 1,
        "next_monkey_false" => 2
      },
      %{
        "monkey_n" => 1,
        "starting_items" => [100]
      },
      %{
        "monkey_n" => 2,
        "starting_items" => [200]
      }
    ]

    expected = [
      %{
        "monkey_n" => 0,
        "starting_items" => [],
        "operation" => "old * 10",
        "test" => "divisible by 2",
        "next_monkey_true" => 1,
        "next_monkey_false" => 2
      },
      %{
        "monkey_n" => 1,
        "starting_items" => [100, 6]
      },
      %{
        "monkey_n" => 2,
        "starting_items" => [200, 3]
      }
    ]

    post_inspect = fn n -> div(n, 3) end
    assert do_turn(Enum.at(turns, 0), turns, post_inspect) === expected
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 11)
    assert part_one(input) == 117_640
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 11, :simple)
    assert part_two(input) == 2_713_310_158
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 11)
    assert part_two(input) == 30_616_425_600
  end

  test "lcm" do
    assert lcm(4, 10) == 20
    assert lcm(6, 15) == 30
    assert lcm(16, 20) == 80
  end
end
