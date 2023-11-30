defmodule AOC.Puzzles.Y2022.Day13 do
  @moduledoc """
  Day 13: Distress Signal
  """

  def parse_pair(pair_string) do
    pair_string
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> Code.eval_string() |> elem(0)))
  end

  def parse(input) do
    input
    |> Enum.join("\n")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_pair/1)
  end

  def log(val, label) do
    IO.inspect(val, label: label, charlists: :as_strings)
  end

  def log(val) do
    IO.inspect(val, charlists: :as_strings)
  end

  # values are the same
  def values_ordered?([val], [val]) do
    log({val, val}, "values_ordered? same boxed")
    nil
  end

  # left ran out
  def values_ordered?(left = [], right) do
    log({left, right}, "values_ordered? left ran out")
    true
  end

  # right ran out
  def values_ordered?(left, right = []) do
    log({left, right}, "values_ordered? right ran out")
    false
  end

  def values_ordered?(l = [left | rest_left], r = [right | rest_right]) do
    log({l, r}, "values_ordered? arr+ left,right")
    log({left, right}, "values_ordered? arr+ hd(left), hd(right)")

    case values_ordered?(left, right) do
      true ->
        true

      false ->
        false

      nil ->
        log({rest_left, rest_right}, "values_ordered? arr+ continue")
        values_ordered?(rest_left, rest_right)
    end
  end

  def values_ordered?([left], [right]) do
    log({left, right}, "values_ordered? arr left,right")
    left < right
  end

  def values_ordered?(left, right) when is_list(left) and not is_list(right) do
    log({left, right}, "values_ordered? box right")
    values_ordered?(left, [right])
  end

  def values_ordered?(left, right) when not is_list(left) and is_list(right) do
    log({left, right}, "values_ordered? box left")
    values_ordered?([left], right)
  end

  # values are the same
  def values_ordered?(val, val) do
    log({val, val}, "values_ordered? numeric same left,right")
    nil
  end

  def values_ordered?(left, right) do
    log({left, right}, "values_ordered? numeric left,right")
    left < right
  end

  # def values_ordered?(left, right) do
  #   log({left, right}, "compare_v left,right")
  # end

  def pair_ordered?(l = [left | rest_left], r = [right | rest_right]) do
    log("-----")
    log({l, r}, "pair_ordered? all l/r")
    log({left, right}, "pair_ordered? hd(l) hd(r)")

    x = values_ordered?(left, right)

    log(x, "pair_ordered? case x")

    case x do
      true -> true
      false -> false
      nil -> pair_ordered?(rest_left, rest_right)
    end
  end

  # left ran out
  def pair_ordered?(left = [], right) do
    log({left, right}, "pair_ordered? left ran out")
    true
  end

  # right ran out
  def pair_ordered?(left, right = []) do
    log({left, right}, "pair_ordered? right ran out")
    false
  end

  # def pair_ordered?([left, right]) do
  #   IO.inspect([left, right], label: "apply pair_ordered?")
  #   x = pair_ordered?(left, right)
  #   IO.inspect(x, label: "?")
  #   x
  # end

  def part_one(input) do
    input
    |> parse()
    |> Enum.map(fn [l, r] ->
      pair_ordered?(l, r)
    end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {x, _i} ->
      x
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
    |> IO.inspect(charlists: :as_strings)
  end

  def part_two(input) do
    input
    |> parse()
  end
end
