defmodule Day6Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
  end

  def simulateDays(list, numberOfDays) do
    1..numberOfDays
    |> Enum.reduce(
         list,
         fn _, acc ->
           # IO.puts("Day #{x}")
           doSimulateOneDay(acc)
         end
       )
  end

  def doSimulateOneDay(list) do
    doSimulateStep(list, [])
  end

  defp doSimulateStep([], newList) do
    newList
  end
  defp doSimulateStep([counter | list], newList) when counter > 0 do
    doSimulateStep(list, [counter - 1 | newList])
  end
  defp doSimulateStep([0 | list], newList) do
    doSimulateStep(list, [6, 8 | newList])
  end
end

defmodule Day6Task2 do
  # the first attempt was fine for the first task but way to slow to the second, so let's make it smarter, just count the different states.

  def createCounts(list) do
    list
    |> Enum.frequencies_by(fn x -> x end)
  end

  def simulateDays(counts, numberOfDays) do
    1..numberOfDays
    |> Enum.reduce(
         counts,
         fn _, acc ->
           #IO.puts("Day #{x}")
           simulateOneDay(acc)
         end
       )
  end

  def simulateOneDay(counts) do
    zero = Map.get(counts, 0, 0)

    updated = 0..7
              |> Enum.reduce(
                   counts,
                   fn x, counts ->
                     Map.put(counts, x, Map.get(counts, x + 1, 0))
                   end
                 )
    updated
    |> Map.put(6, Map.get(updated, 6, 0) + zero)
    |> Map.put(8, zero)
  end
end

# Task 1
Day6Task1.readInput("input1.txt")
|> Day6Task1.simulateDays(80)
|> length
|> IO.inspect

# Task 2
Day6Task1.readInput("input1.txt")
|> Day6Task2.createCounts()
|> Day6Task2.simulateDays(256)
|> Map.values()
|> Enum.sum()
|> IO.inspect
