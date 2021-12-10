defmodule Day10Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
  end

  def parse(list) do
    Enum.reduce(
      list,
      {:ok, []},
      fn
        x, {:ok, list} ->
          if isOpenChar(x) do
            {:ok, List.insert_at(list, 0, x)}
          else
            if x == isOpenChar(List.first(list)) do
              # remove first
              {
                :ok,
                List.pop_at(list, 0)
                |> elem(1)
              }
            else
              {:corruped, x}
            end
          end
        _, {:corruped, x} -> {:corruped, x}
      end
    )
  end

  defp isOpenChar(char) do
    case char do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
      _ -> :false
    end
  end
end


defmodule Day10Task2 do
end

# Task 1
Day10Task1.readInput("input1.txt")
|> Enum.map(&String.graphemes(&1))
|> Enum.map(&Day10Task1.parse(&1))
|> Enum.map(
     fn result ->
       case result do
         {:ok, _} -> 0
         {:corruped, ")"} -> 3
         {:corruped, "]"} -> 57
         {:corruped, "}"} -> 1197
         {:corruped, ">"} -> 25137
       end
     end
   )
|> Enum.sum()
|> IO.inspect

#task 2
results = Day10Task1.readInput("input1.txt")
          |> Enum.map(&String.graphemes(&1))
          |> Enum.map(&Day10Task1.parse(&1))
          |> Enum.filter(fn {result, _} -> result == :ok end)
          |> Enum.map(
               fn {_, list} ->
                 Enum.reduce(
                   list,
                   0,
                   fn
                     "(", acc -> acc * 5 + 1
                     "[", acc -> acc * 5 + 2
                     "{", acc -> acc * 5 + 3
                     "<", acc -> acc * 5 + 4
                   end
                 )
               end
             )
          |> Enum.sort

Enum.at(results, trunc(length(results) / 2))
|> IO.inspect