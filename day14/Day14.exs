defmodule Day14Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    [[input], rules] = content
                       |> String.split("\n\n")
                       |> Enum.map(&String.split(&1, "\n"))

    map = rules
          |> Enum.map(&String.split(&1, " -> "))
          |> Enum.reduce(Map.new, fn [first, second], acc -> Map.put(acc, first, second) end)
    [input, map]
  end


  def performStep(rules, input) do
    Map.keys(input)
    |> Enum.reduce(
         Map.new,
         fn key, map ->
           performSubStep(map, rules, key, input)
         end
       )
  end

  defp performSubStep(pairs, rules, key, input) do
    toInsert = Map.get(rules, key)
    addToMap(pairs, String.at(key, 0) <> toInsert, Map.get(input, key))
    |> addToMap(toInsert <> String.at(key, 1), Map.get(input, key))
  end

  defp addToMap(map, key, count) do
    get = Map.get(map, key, nil)
    if get == nil, do: Map.put(map, key, count), else: Map.put(map, key, get + count)
  end

  def pairsToCounts(pairs, veryFirst) do
    Map.keys(pairs)
    |> Enum.reduce(
         Map.put(Map.new, veryFirst, 1),
         fn key, map ->
           count = Map.get(map, String.at(key, 1), 0)
           Map.put(map, String.at(key, 1), count + Map.get(pairs, key))
         end
       )
  end

end


defmodule Day14Task2 do
end

# Task 1
[input, rules] = Day14Task1.readInput("input1.txt")


# string to pairs
inputList = input
            |> String.graphemes()
pairs = 0..String.length(input) - 2
        |> Enum.reduce(
             Map.new,
             fn i, acc ->
               pair = Enum.at(inputList, i) <> Enum.at(inputList, i + 1)
               Map.put(acc, pair, Map.get(acc, pair, 0) + 1)
             end
           )

# Task 1
resultT1 = 0..9
           |> Enum.reduce(
                pairs,
                fn _, acc ->
                  Day14Task1.performStep(rules, acc)
                end
              )
           |> Day14Task1.pairsToCounts(String.at(input, 0))
           |> Map.values()
           |> Enum.sort
IO.inspect(List.last(resultT1) - List.first(resultT1))

# Task 2
resultT2 = 0..39
           |> Enum.reduce(
                pairs,
                fn _, acc ->
                  Day14Task1.performStep(rules, acc)
                end
              )
           |> Day14Task1.pairsToCounts(String.at(input, 0))
           |> Map.values()
           |> Enum.sort
IO.inspect(List.last(resultT2) - List.first(resultT2))





