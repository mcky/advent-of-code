defmodule AOC.Puzzles.Y2022.Day3 do
  def parse(input) do
    input
  end

  def string_to_set(string) do
    string |> String.split("", trim: true) |> MapSet.new()
  end

  def string_intersection({a, b}) do
    a = string_to_set(a)
    b = string_to_set(b)
    MapSet.intersection(a, b) |> MapSet.to_list()
  end

  def string_intersection_2(strings) do
    strings
    |> Enum.map(&string_to_set/1)
    |> intersection()
  end

  def intersection([head, second]) do
    MapSet.intersection(head, second)
    |> Enum.to_list()
  end

  def intersection([head, second | rest]) do
    intersection = MapSet.intersection(head, second)
    intersection(rest ++ [intersection])
  end

  def str_range() do
    lower = Enum.map(?a..?z, &to_string([&1]))
    upper = Enum.map(?A..?Z, &to_string([&1]))

    Enum.concat(lower, upper)
    |> Enum.with_index(1)
  end

  def priority_for_letter(letter, char_range) do
    Enum.find_value(char_range, fn
      {^letter, idx} -> idx
      {_letter, _idx} -> false
    end)
  end

  def priority(items, char_range) do
    string_intersection(items)
    |> Enum.at(0)
    |> priority_for_letter(char_range)
  end

  def priority_p2(group, char_range) do
    string_intersection_2(group)
    |> Enum.at(0)
    |> priority_for_letter(char_range)
  end

  def part_one(input) do
    char_range = str_range()

    input
    |> Enum.map(fn line ->
      String.split_at(line, div(String.length(line), 2))
    end)
    |> Enum.map(fn line -> priority(line, char_range) end)
    |> Enum.sum()
  end

  def part_two(input) do
    char_range = str_range()

    input
    |> Enum.chunk_every(3)
    |> Enum.map(fn group -> priority_p2(group, char_range) end)
    |> Enum.sum()
  end
end
