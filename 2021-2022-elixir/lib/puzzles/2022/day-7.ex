defmodule AOC.Puzzles.Y2022.Day7 do
  def is_cmd(str), do: String.starts_with?(str, "$")

  def drop_index(list) do
    Enum.map(list, fn {el, _i} -> el end)
  end

  def parse(input) do
    input
    |> Enum.join("\n")
    |> String.replace(~r/^\$/m, "\n$", global: true)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  def resolve_path(_cd_to = "/", _path), do: "/"

  def resolve_path(_cd_to = "..", path) do
    path |> String.split("/") |> Enum.drop(-1) |> Enum.join("/")
  end

  def resolve_path(cd_to, "/"), do: "/#{cd_to}"
  def resolve_path(cd_to, path), do: "#{path}/#{cd_to}"

  def do_cd(cd_to, tree, curr_path) do
    next_path = resolve_path(cd_to, curr_path)

    {tree, next_path}
  end

  def parse_ls_entry("dir " <> dir_name) do
    %{type: "folder", name: dir_name, children: []}
  end

  def parse_ls_entry(entry) do
    [size_s, name] = String.split(entry)
    {size, _rem} = Integer.parse(size_s)
    %{type: "file", name: name, size: size}
  end

  def files_from_ls(file_strings) do
    file_strings
    |> Enum.map(&parse_ls_entry/1)
  end

  def insert_at_path(tree, path, files) do
    p2 =
      path
      |> String.split("/", trim: true)
      |> Enum.flat_map(fn segment ->
        [:children, Access.filter(fn %{name: name} -> name === segment end)]
      end)
      |> Enum.concat([:children])

    put_in(tree, p2, files)
  end

  def do_ls(args, tree, curr_path) do
    files = files_from_ls(args)
    next_tree = insert_at_path(tree, curr_path, files)

    {next_tree, curr_path}
  end

  def get_cmd(command) do
    command |> String.split(" ") |> Enum.at(1)
  end

  def cd_dir_name(cd_cmd) do
    cd_cmd |> String.split(" ") |> Enum.at(2)
  end

  def to_file_tree(commands) do
    init = %{
      type: "folder",
      name: "root",
      children: []
    }

    Enum.reduce(commands, {init, "/"}, fn [cmd | args], {tree, curr_path} ->
      case cmd do
        "$ cd " <> path -> do_cd(path, tree, curr_path)
        "$ ls" -> do_ls(args, tree, curr_path)
      end
    end)
    |> elem(0)
  end

  def sum_files(files) do
    files
    |> Enum.map(&Map.get(&1, :size))
    |> Enum.sum()
  end

  def find_folders(folder = %{type: "folder", children: children, name: name}, found \\ []) do
    child_size =
      folder
      |> flatten_files
      |> sum_files()

    children =
      Enum.flat_map(children, fn
        %{type: "file"} -> []
        child = %{type: "folder"} -> find_folders(child)
      end)

    [%{name: name, size: child_size}] ++ children ++ found
  end

  def flatten_files(tree) do
    flatten_files(tree, [])
  end

  def flatten_files(tree, found) when is_map(tree) do
    if Map.has_key?(tree, :children) do
      tree
      |> Map.get(:children)
      |> Enum.flat_map(fn
        file = %{type: "file"} ->
          [file] ++ found

        child ->
          flatten_files(child, found)
      end)
    else
      found
    end
  end

  def flatten_files(tree, found) when is_list(tree) do
    Enum.flat_map(tree, &flatten_files(&1, found))
  end

  def part_one(input) do
    input
    |> parse()
    |> to_file_tree()
    |> find_folders()
    |> Enum.map(&Map.get(&1, :size))
    |> Enum.filter(&(&1 < 100_000))
    |> Enum.sum()
  end

  def part_two(input) do
    total_space = 70_000_000
    required_space = 30_000_000

    folders =
      input
      |> parse()
      |> to_file_tree()
      |> find_folders()

    root_size = Enum.find_value(folders, fn %{name: "root", size: size} -> size end)

    remaining_space = total_space - root_size

    additional_required = required_space - remaining_space

    folders
    |> Enum.filter(fn %{size: size} ->
      size >= additional_required
    end)
    |> Enum.sort_by(&Map.get(&1, :size))
    |> Enum.at(0)
    |> Map.get(:size)
  end
end
