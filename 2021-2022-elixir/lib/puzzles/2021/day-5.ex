defmodule AOC.Puzzles.Y2021.DayFive do
  def parse_line(line) do
    [from, to] =
      line
      |> String.split(" -> ")
      |> Enum.map(&AOC.Helpers.ints_from_string(&1, ","))

    {from, to}
  end

  def diagonal_coords(_vent = {from, to}) do
    [x1, y1] = from
    [x2, y2] = to

    [
      Enum.into(x1..x2, []),
      Enum.into(y1..y2, [])
    ]
    |> List.zip()
  end

  def non_diag_coords(_vent = {from, to}) do
    [x1, y1] = from
    [x2, y2] = to

    # cartesian of x/y coords
    for x <- x1..x2, y <- y1..y2 do
      {x, y}
    end
  end

  def is_diagonal?({[x1, y1], [x2, y2]})
      when x1 !== x2 and y1 !== y2,
      do: true

  def is_diagonal?(_vent), do: false

  def all_coords_for_vent(vent) do
    if is_diagonal?(vent) do
      diagonal_coords(vent)
    else
      non_diag_coords(vent)
    end
  end

  def draw_vents(vents, hit_counts) do
    flat_coords =
      vents
      |> Enum.flat_map(&Tuple.to_list/1)

    {min_x, max_x} = flat_coords |> Enum.map(&Enum.at(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = flat_coords |> Enum.map(&Enum.at(&1, 1)) |> Enum.min_max()

    hits =
      for y <- min_y..max_y do
        for x <- min_x..max_x do
          case Map.get(hit_counts, {x, y}) do
            nil -> "."
            n -> n
          end
        end
      end

    hits
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()
  end

  def part_one(input) do
    vents =
      input
      |> Enum.map(&parse_line/1)

    all_hits =
      vents
      |> Enum.reject(&is_diagonal?/1)
      |> Enum.flat_map(&all_coords_for_vent/1)

    hit_counts =
      all_hits
      |> Enum.frequencies()

    draw_vents(vents, hit_counts)

    hit_counts
    |> Enum.filter(fn {_, v} -> v >= 2 end)
    |> Enum.count()
  end

  def part_two(input) do
    vents =
      input
      |> Enum.map(&parse_line/1)

    all_hits =
      vents
      |> Enum.flat_map(&all_coords_for_vent/1)

    hit_counts =
      all_hits
      |> Enum.frequencies()

    # draw_vents(vents, hit_counts)

    hit_counts
    |> Enum.filter(fn {_, v} -> v >= 2 end)
    |> Enum.count()
  end
end
