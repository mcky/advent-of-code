defmodule Matrix do
  defstruct items: %{}

  def to_matrix_map(list_of_lists) do
    indexed =
      list_of_lists
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()

    for {row, y} <- indexed do
      for {el, x} <- row do
        {{x, y}, el}
      end
    end
    |> List.flatten()
    |> Map.new()
  end

  def new(list_of_lists) when is_list(list_of_lists) do
    list_of_lists |> to_matrix_map |> new()
  end

  def new(map) when is_map(map) do
    %Matrix{
      items: map
    }
  end

  def at(%Matrix{items: items}, coords = {_x, _y}) do
    Map.fetch(items, coords)
  end

  def at!(%Matrix{items: items}, coords = {_x, _y}) do
    Map.fetch!(items, coords)
  end

  def put(%Matrix{items: items}, coords = {_x, _y}, value) do
    Map.put(items, coords, value)
    |> Matrix.new()
  end

  def all_coords(%Matrix{items: items}) do
    Map.keys(items)
  end

  def dimensions(m = %Matrix{}) do
    keys = all_coords(m)

    {w, _} = Enum.max_by(keys, fn {x, _y} -> x end)
    {_, h} = Enum.max_by(keys, fn {_x, y} -> y end)

    {w, h}
  end

  def minmax(coords) do
    {x_min, _} = Enum.min_by(coords, fn {x, _y} -> x end)
    {x_max, _} = Enum.max_by(coords, fn {x, _y} -> x end)

    {_, y_min} = Enum.min_by(coords, fn {_x, y} -> y end)
    {_, y_max} = Enum.max_by(coords, fn {_x, y} -> y end)

    {{x_min, y_min}, {x_max, y_max}}
  end

  def dimensions2(m = %Matrix{}) do
    keys = all_coords(m)

    # {x_min, _} = Enum.min_by(keys, fn {x, _y} -> x end)
    # {x_max, _} = Enum.max_by(keys, fn {x, _y} -> x end)

    # {_, y_min} = Enum.min_by(keys, fn {_x, y} -> y end)
    # {_, y_max} = Enum.max_by(keys, fn {_x, y} -> y end)

    # {{x_min, y_min}, {x_max, y_max}}
    minmax(keys)
  end

  # { x - 1, y - 1}, { x, y - 1}, { x + 1, y - 1},
  # { x - 1, y    },    x, y      { x + 1, y    },
  # { x - 1, y + 1}, { x, y + 1}, { x + 1, y + 1},
  def diagonal_coordinates(point = {x, y}) do
    [
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y + 1}
    ]
  end

  def all_adjacent_coordinates(point = {x, y}) do
    diagonal_coordinates(point) ++ adjacent_coordinates(point)
  end

  def all_adjacent_coordinates(%Matrix{items: items}, coord) do
    all_adjacent_coordinates(coord)
    |> Enum.filter(&Map.has_key?(items, &1))
  end

  def adjacent_coordinates({x, y}) do
    #         {x, y-1}
    # {x-1, y}  x,y  {x+1, y},
    #         {x, y+1}
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
  end

  def adjacent_coordinates(%Matrix{items: items}, coord) do
    adjacent_coordinates(coord)
    |> Enum.filter(&Map.has_key?(items, &1))
  end

  def adjacent_values(m = %Matrix{}, points = {_x, _y}) do
    adjacent_coordinates(m, points)
    |> Enum.map(&at!(m, &1))
  end

  def has_key(%Matrix{items: items}, key) do
    Map.has_key?(items, key)
  end

  def fill(matrix = %Matrix{}, fill_with) do
    {{x_min, y_min}, {x_max, y_max}} = dimensions2(matrix)

    for x <- x_min..x_max, y <- y_min..y_max, reduce: matrix do
      m ->
        if has_key(m, {x, y}) do
          m
        else
          Matrix.put(m, {x, y}, fill_with)
        end
    end
  end

  def get_repr(matrix = %Matrix{}, value_printer) when is_function(value_printer) do
    # {w, h} = dimensions(matrix)
    {{w0, h0}, {w, h}} = dimensions2(matrix)

    for y <- h0..h do
      for x <- w0..w do
        coord = {x, y}

        case at(matrix, coord) do
          {:ok, v} -> value_printer.({v, coord})
          :error -> value_printer.({:empty, coord})
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def get_repr(matrix = %Matrix{}, coords) when is_list(coords) do
    get_repr(matrix, fn
      {:empty, _coord} ->
        " . "

      {v, coord} ->
        if coord in coords do
          "[#{v}]"
        else
          " #{v} "
        end

      _ ->
        " . "
    end)
  end

  def get_repr(matrix = %Matrix{}) do
    get_repr(matrix, [])
  end

  def print(matrix = %Matrix{}, coords_or_printer_fn \\ []) do
    IO.puts(get_repr(matrix, coords_or_printer_fn))
    matrix
  end

  def print_with_labels(matrix = %Matrix{}, coords_or_printer_fn \\ []) do
    x =
      get_repr(matrix, coords_or_printer_fn)
      |> IO.inspect(label: "x")

    IO.puts(x)
    matrix
  end

  def merge(%Matrix{items: items_a}, %Matrix{items: items_b}) do
    Map.merge(items_a, items_b) |> Matrix.new()
  end

  def count(%Matrix{items: items}) do
    Enum.count(items)
  end

  def map(%Matrix{items: items}, fun) do
    Enum.map(items, fun)
    |> Map.new()
    |> Matrix.new()
  end

  def filter(%Matrix{items: items}, fun) do
    Enum.filter(items, fun)
    |> Map.new()
    |> Matrix.new()
  end

  def find_coordinate(%Matrix{items: items}, fun) do
    Enum.find_value(items, fn {coord, value} ->
      if fun.({coord, value}), do: coord, else: nil
    end)
  end

  def items(%Matrix{items: items}) do
    items
  end

  def values(%Matrix{items: items}) do
    Enum.map(items, fn {_coord, value} -> value end)
  end

  def from_printed(string, split_on \\ " ") do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, split_on, trim: true))
    |> new()
  end
end
