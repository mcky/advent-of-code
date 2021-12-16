defmodule AOC.Puzzles.DayFourteen do
  def to_pair_freqs(string) do
    string
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&Enum.join/1)
    |> Enum.frequencies()
  end

  def parse(input) do
    {[template], rules} =
      input
      |> Enum.reject(fn l -> String.trim(l) == "" end)
      |> Enum.split(1)

    template_freqs = to_pair_freqs(template)

    rules =
      rules
      |> Enum.map(fn line ->
        line |> String.split(" -> ", trim: true) |> List.to_tuple()
      end)
      |> Map.new()

    {template_freqs, rules}
  end

  def do_step(template_freqs, rules) do
    # template_freqs |> IO.inspect(label: "freqs")

    next =
      template_freqs
      |> Enum.reduce(%{}, fn {pair, qty}, acc ->
        # IO.puts("")
        [a, b] = String.split(pair, "", trim: true)

        to_insert = rules[pair]

        # IO.inspect({pair, qty, to_insert}, label: "{p,q,r} -->")

        pair_1 = [a, to_insert] |> Enum.join()
        pair_2 = [to_insert, b] |> Enum.join()

        # Map.get(template_freqs, pair_1, qty)
        how_many_1 = qty
        # Map.get(template_freqs, pair_2, qty)
        how_many_2 = qty

        new =
          [
            {pair_1, how_many_1},
            {pair_2, how_many_2}
          ]
          |> Map.new()

        # |> IO.inspect(label: "nw")

        # IO.inspect(acc, label: "acc")

        merge_sum(acc, new)
      end)

    next
  end

  def merge_sum(a, b) do
    Map.merge(a, b, fn _k, v1, v2 -> v1 + v2 end)
  end

  def do_thing(template_freqs, _rules, 0) do
    template_freqs
  end

  def do_thing(template_freqs, rules, count) do
    do_thing(
      do_step(template_freqs, rules),
      rules,
      count - 1
    )
  end

  def sum_frequencies(freqs) do
    [{first, _} | _] = Enum.to_list(freqs)
    first = String.at(first, 0)

    freqs
    |> Enum.flat_map(fn {pair, qty} ->
      [a, b] = String.split(pair, "", trim: true)
      [{a, qty}]
    end)
    |> Enum.concat([{first, 1}])
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      Map.update(acc, k, v, fn ex_v -> ex_v + v end)
    end)
  end

  def solve(input, iterations) do
    {template, rules} =
      input
      |> parse()

    {{_, min}, {_, max}} =
      do_thing(template, rules, iterations)
      |> sum_frequencies()
      |> Enum.min_max_by(fn {_, freq} -> freq end)

    max - min
  end

  def part_one(input) do
    solve(input, 10)
  end

  def part_two(input) do
    # Off by 1 for real input
    solve(input, 40)
  end
end
