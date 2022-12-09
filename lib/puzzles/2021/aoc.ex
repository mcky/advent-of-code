defmodule AOC.Y2021 do
  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(2021, 17)
    |> AOC.Puzzles.Y2021.DaySeventeen.part_one()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
