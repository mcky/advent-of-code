defmodule AOC.Puzzles.Y2021.DayTen do
  def parse_line(line), do: String.graphemes(line)

  def parse(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  # I used a list to keep track of all open chunks. Whenever encountered an opening chunk,
  # I appended it to the list. Whenever encountered a closing chunk,
  # I checked if the last item in my list is a matching opening chunk.
  # If so, I deleted the last item and continued. If not, it means the line
  # is invalid. Upon reaching the end of the line, if there are any opening chunks
  # left in the list, it means the line is not complete.

  def opposite(")"), do: "("
  def opposite("("), do: ")"
  def opposite("}"), do: "{"
  def opposite("{"), do: "}"
  def opposite("]"), do: "["
  def opposite("["), do: "]"
  def opposite(">"), do: "<"
  def opposite("<"), do: ">"

  def parse_expressions(symbols) do
    res =
      Enum.reduce_while(symbols, [], fn
        symb, stack when symb in ["(", "[", "{", "<"] ->
          {:cont, [symb | stack]}

        symb, stack when symb in [")", "]", "}", ">"] ->
          [top | rest] = stack

          if top === opposite(symb) do
            {:cont, rest}
          else
            {:halt, {:invalid, symb}}
          end

        _, _ ->
          {:halt, :unknown}
      end)

    case res do
      [] -> :valid
      items when is_list(items) -> {:incomplete, items}
      {:invalid, s} -> {:invalid, s}
      :unknown -> :unknown
    end
  end

  def invalid_symbol_points(")"), do: 3
  def invalid_symbol_points("]"), do: 57
  def invalid_symbol_points("}"), do: 1197
  def invalid_symbol_points(">"), do: 25137

  def sum_syntax_errors(lines) do
    lines
    |> Enum.map(&parse_expressions/1)
    |> Enum.filter(&match?({:invalid, _symbol}, &1))
    |> Enum.map(fn {_, symbol} -> invalid_symbol_points(symbol) end)
    |> Enum.sum()
  end

  def autocomp_symbol_points(")"), do: 1
  def autocomp_symbol_points("]"), do: 2
  def autocomp_symbol_points("}"), do: 3
  def autocomp_symbol_points(">"), do: 4

  def balanced_brackets(symbols) do
    symbols
    |> Enum.map(&opposite/1)
  end

  def score_incomplete_symbols(symbols) do
    Enum.reduce(symbols, 0, fn symb, acc ->
      acc * 5 + autocomp_symbol_points(symb)
    end)
  end

  def middle_item(list) do
    idx = ((length(list) - 1) / 2) |> trunc()
    Enum.at(list, idx)
  end

  def sum_completions(lines) do
    lines
    |> Enum.map(&parse_expressions/1)
    |> Enum.filter(&match?({:incomplete, _symbol}, &1))
    |> Enum.map(fn {_, symbol} -> balanced_brackets(symbol) end)
    |> Enum.map(&score_incomplete_symbols/1)
    |> Enum.sort()
    |> middle_item()
  end

  def part_one(input) do
    input
    |> parse()
    |> sum_syntax_errors()
  end

  def part_two(input) do
    input
    |> parse()
    |> sum_completions()
  end
end
