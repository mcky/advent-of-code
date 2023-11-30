defmodule AocTest.Y2022.Day7 do
  use ExUnit.Case
  doctest AOC.Puzzles.Y2022.Day7
  import AOC.Puzzles.Y2022.Day7

  test "part 1 (sample)" do
    input = AOC.Setup.get_input(2022, 7, :simple)
    assert part_one(input) == 95437
  end

  test "insert_at_path" do
    in_tree = %{
      children: [
        %{name: "a", type: "folder", children: []},
        %{name: "b.txt", size: 14_848_514, type: "file"},
        %{name: "c.dat", size: 8_504_156, type: "file"},
        %{name: "d", type: "folder", children: []}
      ],
      name: "/",
      path: "/",
      type: "folder"
    }

    out_tree = %{
      children: [
        %{
          name: "a",
          type: "folder",
          children: [
            %{name: "insert_this"}
          ]
        },
        %{name: "b.txt", size: 14_848_514, type: "file"},
        %{name: "c.dat", size: 8_504_156, type: "file"},
        %{name: "d", type: "folder", children: []}
      ],
      name: "/",
      path: "/",
      type: "folder"
    }

    assert insert_at_path(in_tree, "/a", [%{name: "insert_this"}]) == out_tree
  end

  test "find_folders" do
    tree = %{
      name: "a",
      type: "folder",
      children: [
        %{
          name: "e",
          type: "folder",
          children: [
            %{name: "i", size: 584, type: "file"}
          ]
        },
        %{name: "f", size: 29116, type: "file"},
        %{name: "g", size: 2557, type: "file"},
        %{name: "h.lst", size: 62596, type: "file"}
      ]
    }

    assert find_folders(tree) == [
             %{name: "a", size: 94853},
             %{name: "e", size: 584}
           ]
  end

  test "flatten_files" do
    tree = %{
      children: [
        %{
          children: [
            %{name: "i", size: 584, type: "file"}
          ],
          name: "e",
          type: "folder"
        },
        %{name: "f", size: 29116, type: "file"},
        %{name: "g", size: 2557, type: "file"},
        %{name: "h.lst", size: 62596, type: "file"}
      ],
      name: "a",
      type: "folder"
    }

    files = [
      %{name: "i", size: 584, type: "file"},
      %{name: "f", size: 29116, type: "file"},
      %{name: "g", size: 2557, type: "file"},
      %{name: "h.lst", size: 62596, type: "file"}
    ]

    assert flatten_files(tree) === files
  end

  test "part 1" do
    input = AOC.Setup.get_input(2022, 7)
    assert part_one(input) == 1_444_896
  end

  test "part 2 (sample)" do
    input = AOC.Setup.get_input(2022, 7, :simple)
    assert part_two(input) == 24_933_642
  end

  test "part 2" do
    input = AOC.Setup.get_input(2022, 7)
    assert part_two(input) == 404_395
  end
end
