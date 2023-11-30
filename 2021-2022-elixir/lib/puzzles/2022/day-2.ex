defmodule AOC.Puzzles.Y2022.Day2 do
  def parse(input) do
    input
    |> Enum.map(&String.split(&1, " "))
  end

  def ordered_shapes, do: [:rock, :paper, :scissors]

  def at_idx(list, i) when is_list(list) and is_number(i) do
    clamped_idx = rem(i, length(list))
    Enum.at(list, clamped_idx)
  end

  def winning_shape(shape) do
    i = Enum.find_index(ordered_shapes(), fn s -> s === shape end)
    at_idx(ordered_shapes(), i + 1)
  end

  def losing_shape(shape) do
    i = Enum.find_index(ordered_shapes(), fn s -> s === shape end)
    at_idx(ordered_shapes(), i - 1)
  end

  def is_win([shape, shape]), do: nil
  def is_win([them, you]) do
    you == winning_shape(them)
  end

  def outcome_score(true), do: 6
  def outcome_score(false), do: 0
  def outcome_score(nil), do: 3

  def shape_score(:rock), do: 1
  def shape_score(:paper), do: 2
  def shape_score(:scissors), do: 3

  def score_for_round(round = [_them, you]) do
    round
    |> is_win()
    |> outcome_score()
    |> (&(&1 + shape_score(you))).()
  end

  # Part 1
  def to_shape_p1("A"), do: :rock
  def to_shape_p1("B"), do: :paper
  def to_shape_p1("C"), do: :scissors

  def to_shape_p1("X"), do: :rock
  def to_shape_p1("Y"), do: :paper
  def to_shape_p1("Z"), do: :scissors

  def part_one(input) do
    input
    |> parse()
    |> Enum.map(fn l -> Enum.map(l, &to_shape_p1/1) end)
    |> Enum.map(&score_for_round/1)
    |> Enum.sum()
  end

  # Part 2

  def to_outcome_p2("X"), do: false
  def to_outcome_p2("Y"), do: nil
  def to_outcome_p2("Z"), do: true

  def shape_for_outcome(true, them), do: winning_shape(them)
  def shape_for_outcome(false, them), do: losing_shape(them)
  def shape_for_outcome(nil, them), do: them

  def to_shapes_p2([them, you]) do
    their_shape = to_shape_p1(them)
    outcome = to_outcome_p2(you)
    your_shape = shape_for_outcome(outcome, their_shape)

    score_for_round([their_shape, your_shape])
  end

  def part_two(input) do
    input
    |> parse()
    |> Enum.map(&to_shapes_p2/1)
    |> Enum.sum()
  end
end
