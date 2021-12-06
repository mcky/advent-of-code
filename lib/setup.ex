defmodule AOC.Setup do
  @input_dir Path.join(:code.priv_dir(:aoc), "inputs")

  def fetch_task_input(day_n) do
    url = "https://adventofcode.com/2021/day/#{day_n}/input"

    session_token = System.get_env("AOC_SESSION")

    case HTTPoison.get(url, %{},
           hackney: [
             cookie: [
               "session=#{session_token}"
             ]
           ]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :notfound}
      _ -> {:error}
    end
  end

  def input_path(day_n, :simple), do: Path.join(@input_dir, "day-#{day_n}-simple.txt")
  def input_path(day_n), do: Path.join(@input_dir, "day-#{day_n}.txt")

  def download_input(day_n) do
    file_name = input_path(day_n)

    with {:ok, body} <- fetch_task_input(day_n),
         :ok <- File.write(file_name, body) do
      :ok
    else
      _ -> :error
    end
  end

  def format_file(input) do
    input
    |> Enum.map(&String.trim/1)
  end

  def get_input(day_n, :simple) do
    file_name = input_path(day_n, :simple)

    File.stream!(file_name)
    |> format_file
  end

  def get_input(day_n) do
    file_name = input_path(day_n)

    if File.exists?(file_name) do
      File.stream!(file_name)
      |> format_file
    else
      download_input(day_n)
      get_input(day_n)
    end
  end
end
