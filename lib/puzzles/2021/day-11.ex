defmodule AOC.Puzzles.Y2021.DayEleven do
  def parse(input) do
    input
    |> Enum.map(fn line ->
      line
      |> AOC.Helpers.ints_from_string("")
      |> Enum.map(fn n -> {n, false} end)
    end)
    |> Matrix.new()
  end

  def print_flashes(matrix) do
    values_only =
      matrix
      |> Matrix.map(fn
        {k, {v, _flashing}} -> {k, v}
      end)

    Matrix.print(values_only)
  end

  def charge({n, flashed}), do: {n + 1, flashed}

  def maybe_reset({_n, _flashed = true}), do: {0, false}
  def maybe_reset({n, _flashed = false}), do: {n, false}

  def trigger_neighbor_flashes([], matrix), do: matrix

  def trigger_neighbor_flashes([point | rest], matrix) do
    {value, did_flash} = Matrix.at!(matrix, point)

    if value > 9 and !did_flash do
      # Mark the current coordinates as having flashed
      with_flash_marked =
        matrix.items
        |> Map.update!(point, fn {v, _} -> {v, true} end)

      # Iterate over adjacent points, updating and saving
      # their score to a new matrix
      adjacent_updated =
        matrix
        |> Matrix.all_adjacent_coordinates(point)
        |> Enum.reduce(with_flash_marked, fn adj, acc ->
          Map.update!(
            acc,
            adj,
            fn {v, adj_did_flash} -> {v + 1, adj_did_flash} end
          )
        end)
        |> Matrix.new()

      # Since we've potentially made more flash-able points,
      # re-start the list cycle
      all_points_again = Matrix.all_coords(adjacent_updated)
      trigger_neighbor_flashes(all_points_again, adjacent_updated)
    else
      trigger_neighbor_flashes(rest, matrix)
    end
  end

  def do_day(octopuses) do
    # First, the energy level of each octopus increases by 1.
    charged_octopuses =
      octopuses
      |> Matrix.map(fn {k, v} -> {k, charge(v)} end)

    # Then, any octopus with an energy level greater than 9 flashes.
    # This increases the energy level of all adjacent octopuses by 1,
    # including octopuses that are diagonally adjacent. If this causes
    # an octopus to have an energy level greater than 9, it also flashes.
    # This process continues as long as new octopuses keep having their
    # energy level increased beyond 9. (An octopus can only flash at most
    # once per step.)
    coordinates_list = Matrix.all_coords(charged_octopuses)
    flashed_octopuses = trigger_neighbor_flashes(coordinates_list, charged_octopuses)

    flash_count =
      flashed_octopuses.items
      |> Map.to_list()
      |> Enum.filter(&match?({_p, {_n, true}}, &1))
      |> Enum.count()

    # Finally, any octopus that flashed during this step has its
    # energy level set to 0, as it used all of its energy to flash.
    reset_octopuses =
      flashed_octopuses
      |> Matrix.map(fn {k, v} -> {k, maybe_reset(v)} end)

    {reset_octopuses, flash_count}
  end

  def sum_flashes_for_steps(octopuses, days_remaining) do
    sum_flashes_for_steps(octopuses, days_remaining, 0, 0)
  end

  def sum_flashes_for_steps(_octopuses, _days_remaining = 0, _days_gone, flash_count) do
    flash_count
  end

  def sum_flashes_for_steps(octopuses, days_remaining, days_gone, flash_count) do
    {next_octopuses, next_flash_count} = do_day(octopuses)

    sum_flashes_for_steps(
      next_octopuses,
      days_remaining - 1,
      days_gone + 1,
      flash_count + next_flash_count
    )
  end

  def min_steps_simultanious_flashes(octopuses) do
    size = Enum.count(octopuses.items)
    min_steps_simultanious_flashes(octopuses, 0, 0, size)
  end

  def min_steps_simultanious_flashes(_octopuses, days_gone, flash_count, matrix_size)
      when flash_count == matrix_size do
    days_gone
  end

  def min_steps_simultanious_flashes(octopuses, days_gone, _flash_count, matrix_size) do
    {next_octopuses, next_flash_count} = do_day(octopuses)

    min_steps_simultanious_flashes(
      next_octopuses,
      days_gone + 1,
      next_flash_count,
      matrix_size
    )
  end

  def part_one(input) do
    input
    |> parse()
    |> sum_flashes_for_steps(100)
  end

  def part_two(input) do
    input
    |> parse()
    |> min_steps_simultanious_flashes
  end
end
