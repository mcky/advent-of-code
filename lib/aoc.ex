defmodule AOC do
  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(13)
    |> AOC.Puzzles.DayThirteen.part_two()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
