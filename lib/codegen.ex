defmodule AOC.Codegen do
  def add_eof(str), do: str ++ "\n"

  def test_file(year, day_n) do
    """
      defmodule AocTest.Y#{year}.Day#{day_n} do
        use ExUnit.Case
        doctest AOC.Puzzles.Y#{year}.Day#{day_n}
        import AOC.Puzzles.Y#{year}.Day#{day_n}

        test "part 1 (sample)" do
          input = AOC.Setup.get_input(#{year}, #{day_n}, :simple)
          assert part_one(input) == nil
        end

        @tag :skip
        test "part 1" do
          input = AOC.Setup.get_input(#{year}, #{day_n})
          assert part_one(input) == nil
        end

        @tag :skip
        test "part 2 (sample)" do
          input = AOC.Setup.get_input(#{year}, #{day_n}, :simple)
          assert part_two(input) == nil
        end

        @tag :skip
        test "part 2" do
          input = AOC.Setup.get_input(#{year}, #{day_n})
          assert part_two(input) == nil
        end
      end
    """
    |> Code.format_string!()
    |> add_eof()
  end

  def impl_file(year, day_n) do
    """
      defmodule AOC.Puzzles.Y#{year}.Day#{day_n} do
        def parse(input) do
          input
        end

        def part_one(input) do
          input
          |> parse()
        end

        def part_two(input) do
          input
          |> parse()
        end
      end
    """
    |> Code.format_string!()
    |> add_eof()
  end

  def test_path(year, day_n), do: "./test/#{year}/day-#{day_n}_test.exs"
  def impl_path(year, day_n), do: "./lib/puzzles/#{year}/day-#{day_n}.ex"

  def parse_args() do
    sample_input =
      IO.stream()
      |> Enum.to_list()

    {[year: year, day: day], _, _} =
      System.argv()
      |> OptionParser.parse(strict: [day: :integer, year: :integer])

    {year, day, sample_input}
  end

  def main() do
    {year, day_n, sample_input} = parse_args()

    with :ok <- File.write(test_path(year, day_n), test_file(year, day_n)),
         :ok <- File.write(AOC.Setup.input_path(year, day_n, :simple), sample_input),
         :ok <- File.write(impl_path(year, day_n), impl_file(year, day_n)) do
      IO.puts("done")
    end
  end
end
