defmodule AOC do
  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(17)
    |> AOC.Puzzles.DaySeventeen.part_one()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
