defmodule AOC.Puzzles.Y2022.Day10 do
  def parse(input) do
    input
  end

  def do_instruction("noop", register) do
    {register, [register]}
  end

  def do_instruction("addx " <> n, register) do
    next = register + AOC.Helpers.safe_parse_int(n)
    {next, [register, register]}
  end

  def do_instructions(instructions) do
    {_, cycles} =
      Enum.reduce(instructions, {1, [1]}, fn instruction, {register, cycles} ->
        {next_register, next_cycles} = do_instruction(instruction, register)

        {next_register, cycles ++ next_cycles}
      end)

    cycles
  end

  def take_strengths(cycles) do
    20..length(cycles)//40
    |> Enum.to_list()
    |> Enum.map(fn idx ->
      idx * Enum.at(cycles, idx)
    end)
  end

  def crt_line(cycles) do
    for {register, i} <- Enum.with_index(cycles) do
      sprite_idx = (register - 1)..(register + 1)
      if i in sprite_idx, do: "#", else: "."
    end
    |> Enum.join("")
  end

  def draw_crt(cycles) do
    crt =
      cycles
      |> Enum.drop(1)
      |> Enum.chunk_every(40)
      |> Enum.map(&crt_line/1)

    # IO.puts("")
    # IO.puts(Enum.join(crt, "\n"))

    crt
  end

  def part_one(input) do
    input
    |> parse()
    |> do_instructions()
    |> take_strengths()
    |> Enum.sum()
  end

  def part_two(input) do
    input
    |> parse()
    |> do_instructions()
    |> draw_crt()
  end
end
