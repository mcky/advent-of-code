defmodule AOC.Puzzles.DayThree do
  defp parse_line(line) do
    line
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp most_common(list) do
    {n, _freq} =
      Enum.frequencies(list)
      # {n => freq} sort descending by n
      |> Enum.sort(:desc)
      |> Enum.max_by(fn {_n, count} -> count end)

    n
  end

  defp least_common(list) do
    {n, _freq} =
      Enum.frequencies(list)
      |> Enum.sort(:asc)
      |> Enum.min_by(fn {_n, count} -> count end)

    n
  end

  defp numlist_to_decimal(l) do
    {dec, _} = l |> Enum.join() |> Integer.parse(2)
    dec
  end

  defp gamma(transposed) do
    Enum.map(transposed, &most_common/1)
    |> numlist_to_decimal()
  end

  defp epsilon(transposed) do
    Enum.map(transposed, &least_common/1)
    |> numlist_to_decimal()
  end

  def part_one(input) do
    values =
      input
      |> Enum.map(&parse_line/1)

    transposed = AOC.Helpers.transpose(values)

    gamma(transposed) * epsilon(transposed)
  end

  def part_two(input) do
    values =
      input
      |> Enum.map(&parse_line/1)

    ct =
      values
      |> Enum.at(0)
      |> Enum.count()
      |> (fn n -> n - 1 end).()
      |> IO.inspect()

    o2 =
      Enum.reduce(
        0..ct,
        values,
        fn pos, remaining ->
          com = AOC.Helpers.transpose(remaining) |> Enum.at(pos) |> most_common()

          Enum.filter(remaining, fn xx -> Enum.at(xx, pos) === com end)
        end
      )
      |> Enum.at(0)
      |> numlist_to_decimal

    co2 =
      Enum.reduce(
        0..ct,
        values,
        fn pos, remaining ->
          l_com = AOC.Helpers.transpose(remaining) |> Enum.at(pos) |> least_common()
          Enum.filter(remaining, fn xx -> Enum.at(xx, pos) === l_com end)
        end
      )
      |> Enum.at(0)
      |> numlist_to_decimal

    %{
      :o2 => o2,
      :co2 => co2
    }
  end
end
