defmodule AOC do
  @on_load :current_day

  def current_day do
    HTTPoison.start()

    AOC.Setup.get_input(6, :simple)
    |> AOC.Puzzles.DaySix.part_two()
    |> IO.inspect(charlists: :as_lists, label: "Result")

    :ok
  end
end
