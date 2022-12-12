defmodule AOC.Puzzles.Y2022.Day11 do
  def parse_line(re, string) do
    Regex.run(re, string, capture: :all_but_first)
    |> hd()
  end

  def parse_line_numeric(re, string) do
    parse_line(re, string)
    |> AOC.Helpers.safe_parse_int()
  end

  def parse_monkey(monkey_lines) do
    %{
      monkey_n: parse_line_numeric(~r/Monkey (\d+):/, monkey_lines),
      starting_items:
        parse_line(~r/Starting items: (.+)/, monkey_lines)
        |> AOC.Helpers.ints_from_string(", "),
      operation: parse_line(~r/Operation: new = (.+)/, monkey_lines),
      divisible_by: parse_line_numeric(~r/Test: divisible by (.+)/, monkey_lines),
      next_monkey_true: parse_line_numeric(~r/If true: throw to monkey (.+)/, monkey_lines),
      next_monkey_false: parse_line_numeric(~r/If false: throw to monkey (.+)/, monkey_lines),
      inspect_count: 0
    }
  end

  def parse(input) do
    input
    |> Enum.join("\n")
    |> String.split("\n\n")
    |> Enum.map(&parse_monkey/1)
  end

  def do_operation(worry_level, "old * old") do
    worry_level * worry_level
  end

  def do_operation(worry_level, "old * " <> n) do
    worry_level * AOC.Helpers.safe_parse_int(n)
  end

  def do_operation(worry_level, "old + " <> n) do
    worry_level + AOC.Helpers.safe_parse_int(n)
  end

  def do_test(worry_level, divisible_by, if_true, if_false) do
    if rem(worry_level, divisible_by) === 0 do
      if_true
    else
      if_false
    end
  end

  def inspect_item(
        item,
        _monkey = %{
          operation: operation,
          divisible_by: divisible_by,
          next_monkey_true: next_monkey_true,
          next_monkey_false: next_monkey_false
        },
        post_inspect
      ) do
    worry_level =
      item
      |> do_operation(operation)
      |> post_inspect.()

    next_monkey = do_test(worry_level, divisible_by, next_monkey_true, next_monkey_false)
    {worry_level, next_monkey}
  end

  def do_turn(turn, init_turns_state, post_inspect) do
    %{monkey_n: monkey_n, starting_items: starting_items} = turn

    Enum.reduce(starting_items, init_turns_state, fn item, turns_state ->
      {to_throw, monkey_to} = inspect_item(item, turn, post_inspect)

      update_in(turns_state, [Access.at(monkey_to), :starting_items], fn monkey_to_items ->
        monkey_to_items ++ [to_throw]
      end)
    end)
    |> put_in([Access.at(monkey_n), :starting_items], [])
    |> update_in([Access.at(monkey_n), :inspect_count], fn x -> x + length(starting_items) end)
  end

  def take_turns(turns, post_inspect) do
    take_turns(turns, turns, post_inspect)
  end

  def take_turns([turn | rest_turns], state, post_inspect) do
    %{monkey_n: monkey_n} = turn

    matching_from_state =
      Enum.find(state, fn
        %{monkey_n: ^monkey_n} -> true
        _ -> false
      end)

    next_state = do_turn(matching_from_state, state, post_inspect)

    take_turns(rest_turns, next_state, post_inspect)
  end

  def take_turns([], state, _post_inspect) do
    state
  end

  def do_rounds(turns, n_rounds, post_inspect) do
    Enum.reduce(1..n_rounds, turns, fn _round, acc ->
      take_turns(acc, post_inspect)
    end)
  end

  def lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end

  def score(state) do
    state
    |> Enum.map(&Map.get(&1, :inspect_count))
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  def part_one(input) do
    parse(input)
    |> do_rounds(20, fn n -> div(n, 3) end)
    |> score()
  end

  def part_two(input) do
    monkeys = parse(input)

    divisible_lcm =
      monkeys
      |> Enum.map(&Map.get(&1, :divisible_by))
      |> Enum.reduce(&lcm/2)

    do_rounds(monkeys, 10_000, fn n -> rem(n, divisible_lcm) end)
    |> score()
  end
end
