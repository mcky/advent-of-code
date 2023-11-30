defmodule AOC.Puzzles.Y2021.DaySix do
  def parse(input) do
    input
    |> Enum.at(0)
    |> AOC.Helpers.ints_from_string(",")
    |> Enum.frequencies()
  end

  def age_fish({0, count}), do: {6, count}
  def age_fish({age, count}), do: {age - 1, count}

  def multiply(%{0 => num_zeroes}), do: %{8 => num_zeroes}
  def multiply(_fish), do: %{}

  def pairs_to_freq(pairs) do
    Enum.reduce(pairs, %{}, fn {age, count}, acc ->
      Map.update(acc, age, count, fn curr_count -> curr_count + count end)
    end)
  end

  def do_day(fish) do
    aged_fish =
      fish
      |> Enum.map(&age_fish/1)
      |> pairs_to_freq

    babies = multiply(fish)

    Map.merge(aged_fish, babies)
  end

  def breed_fishies(fish, 0, _gone) do
    fish
  end

  def breed_fishies(fish, days_remaining, days_gone) do
    breed_fishies(do_day(fish), days_remaining - 1, days_gone + 1)
  end

  def count_fish(fish_frequencies) when is_map(fish_frequencies) do
    Enum.reduce(fish_frequencies, 0, fn {_k, count}, acc ->
      acc + count
    end)
  end

  def part_one(input) do
    input
    |> parse
    |> breed_fishies(80, 0)
    |> count_fish()
  end

  def part_two(input) do
    input
    |> parse
    |> breed_fishies(256, 0)
    |> count_fish()
  end
end
