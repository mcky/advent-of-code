defmodule AOC.Setup do
  @input_dir Path.join(:code.priv_dir(:aoc), "inputs")

  def fetch_task_input(year, day_n) do
    url = "https://adventofcode.com/#{year}/day/#{day_n}/input"

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
      {:ok, %HTTPoison.Response{status_code: 400}} -> {:error, :invalid_session}
      {:error, err} -> {:error, err}
    end
  end

  def input_path(year, day_n, :simple),
    do: Path.join(@input_dir, "#{year}/day-#{day_n}-simple.txt")

  def input_path(year, day_n), do: Path.join(@input_dir, "#{year}/day-#{day_n}.txt")

  def download_input(year, day_n) do
    file_name = input_path(year, day_n)

    with {:ok, body} <- fetch_task_input(year, day_n),
         :ok <- File.write(file_name, body) do
      :ok
    else
      err -> err
    end
  end

  def format_file(input) do
    input
    |> Enum.map(&String.replace(&1, "\n", ""))
  end

  def get_input(year, day_n, :simple) do
    file_name = input_path(year, day_n, :simple)

    File.stream!(file_name)
    |> format_file
  end

  def get_input(year, day_n) do
    file_name = input_path(year, day_n)

    if File.exists?(file_name) do
      File.stream!(file_name)
      |> format_file
    else
      with :ok <- download_input(year, day_n) do
        get_input(year, day_n)
      else
        err ->
          IO.inspect(err)
          raise "Download error"
      end
    end
  end
end
