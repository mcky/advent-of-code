defmodule AOC.Puzzles.DayFourteen do
  def to_pairs(string) do
    string
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
  end

  def parse(input) do
    {[template], rules} =
      input
      |> Enum.reject(fn l -> String.trim(l) == "" end)
      |> Enum.split(1)

    rules =
      rules
      |> Enum.map(fn line ->
        line |> String.split(" -> ", trim: true) |> List.to_tuple()
      end)
      |> Map.new()

    {template, rules}
  end

  def do_thing(pattern, rules, 0) do
    pattern
  end

  def do_thing(pattern, rules, count) do
    last = String.at(pattern, -1)

    next =
      pattern
      |> to_pairs()
      |> Enum.map(fn pair ->
        [a, b] = String.split(pair, "", trim: true)
        [a, rules[pair]] |> Enum.join()
      end)
      |> Enum.concat([last])
      |> Enum.join()

    do_thing(next, rules, count - 1)
  end

  def part_one(input) do
    {template, rules} =
      input
      |> parse()

    {{_, min}, {_, max}} =
      do_thing(template, rules, 10)
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.min_max_by(fn {_, freq} -> freq end)

    max - min
  end

  def part_two(input) do
    input
    |> parse()
  end
end
