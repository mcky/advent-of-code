defmodule AOC do
  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(15, :simple)
    |> AOC.Puzzles.DayFifteen.part_two()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
