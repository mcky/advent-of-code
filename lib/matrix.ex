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

  def at(%Matrix{items: items}, points = {_x, _y}) do
    Map.fetch!(items, points)
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

  def neighboring_coordinates(%Matrix{items: items}, _points = {x, y}, :all) do
    [
      # {x-1, y-1},{x, y-1},{x+1, y-1},
      # {x-1, y  },  x,y    {x+1, y  },
      # {x-1, y+1},{x, y+1},{x+1, y+1},
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
    |> Enum.filter(&Map.has_key?(items, &1))
  end

  def neighboring_coordinates(%Matrix{items: items}, _points = {x, y}) do
    #         {x, y-1}
    # {x-1, y}  x,y  {x+1, y},
    #         {x, y+1}
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]
    |> Enum.filter(&Map.has_key?(items, &1))
  end

  def neighboring_values(m = %Matrix{}, points = {_x, _y}) do
    neighboring_coordinates(m, points)
    |> Enum.map(&at(m, &1))
  end

  def get_repr(matrix = %Matrix{}, coords \\ []) do
    {w, h} = dimensions(matrix)

    for y <- 0..h do
      for x <- 0..w do
        curr_coord = {x, y}
        v = at(matrix, {x, y})

        if curr_coord in coords do
          "[#{v}]"
        else
          " #{v} "
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
  end

  def print(matrix = %Matrix{}, coords \\ []) do
    IO.puts(get_repr(matrix, coords))
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

  def values(%Matrix{items: items}) do
    Enum.map(items, fn {_coord, value} -> value end)
  end
end
