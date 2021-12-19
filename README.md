# Advent of code 2021 solutions

No fancy code loading mechanism currently, swap out the code in `lib/aoc.ex` for the current day's solution.

```
AOC.Setup.get_input(6, :simple)
  |> AOC.Puzzles.DaySix.part_two()
```

`AOC.Setup.get_input/1` will use your session token to fetch and then save and serve the current days input from `priv/inputs`

Passing `:simple` to `AOC.Setup.get_input/2` will look for `day-$n-simple.txt` in the `priv/inputs` folder, simple meaning the examples given in the body of the task description.

To reload on code changes and run the current task

```
# brew install fd entr
mix deps.get

fd . -e ex './lib/' | AOC_SESSION="your_session_token" entr mix run -e AOC.current_day
```

## Solutions

| Day    | Part one | Part 2 |
|--------|----------|--------|
| **1**  | ✅        | ✅      |
| **2**  | ✅        | ✅      |
| **4**  | ✅        | ✅      |
| **5**  | ✅        | ✅      |
| **6**  | ✅        | ✅      |
| **7**  | ✅        | ✅      |
| **8**  | ✅        | ❌      |
| **9**  | ✅        | ✅      |
| **10** | ✅        | ✅      |
| **11** | ✅        | ✅      |
| **12** | ✅        | ❌      |
| **13** | ✅        | ✅      |
| **14** | ✅        | ✅      |
| **15** | ✅        | ✅      |
| **16** | ✅        | ✅      |

<!--
| **17** |        |      |
| **18** |        |      |
| **19** |        |      |
| **20** |        |      |
| **21** |        |      |
| **22** |        |      |
| **23** |        |      |
| **24** |        |      |
| **25** |        |      |
-->
