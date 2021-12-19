defmodule AOC do
  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(16)
    |> AOC.Puzzles.DaySixteen.part_two()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
