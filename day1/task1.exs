defmodule Day1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
  end

  def calculateSumWindow(list, windowSize) do
    doSumWindow(list, Enum.count(list), windowSize, [])
  end

  def countIncreases(list) do
    {ret, _} = list
    |> Enum.reduce(
        {0, nil},
        fn
          x, {0, nil} -> {0, x}
          x, {count, lastNumber} ->
            if x > lastNumber do
              {count + 1, x}
            else
              {count, x}
            end
        end
      )
    ret
  end

  defp doSumWindow([_|t] = inputList, listCount, windowSize, resultList) when listCount >= windowSize do
    sum = inputList
    |> Enum.slice(0..windowSize-1)
    |> Enum.sum()
    doSumWindow(t, listCount - 1, windowSize, resultList ++ [sum])
  end
  defp doSumWindow(_, _, _, resultList) do resultList end
end


Day1.readInput("input1.txt")
|> Day1.countIncreases()
|> IO.inspect


Day1.readInput("input1.txt")
|> Day1.calculateSumWindow(3)
|> Day1.countIncreases()
|> IO.inspect