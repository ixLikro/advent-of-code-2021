defmodule Day7Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split(",")
    |> Enum.map(&String.to_integer(&1))
  end

  def getMean(list) do
    Enum.sum(list) / length(list)
  end

  def getMedian(list) do
    sorted = Enum.sort(list)
    Enum.at(sorted, div(length(sorted), 2))
  end

  def calcNeededFuel(list, pos) do
    list
    |> Enum.map(fn x -> abs(pos - x) end)
    |> Enum.sum
  end

  def calcNeededFuelList(list, posList) do
    Enum.map(posList, fn pos -> {pos, calcNeededFuel(list, pos)} end)
  end

end

defmodule Day7Task2 do

  def calcNeededFuel(list, pos) do
    list
    |> Enum.map(fn x ->
      distance = abs(pos - x)
      (distance * (distance + 1)) / 2
    end)
    |> Enum.sum
  end

  def calcNeededFuelList(list, posList) do
    Enum.map(posList, fn pos -> {pos, calcNeededFuel(list, pos)} end)
  end

end

# Task 1
list = Day7Task1.readInput("input1.txt")

median = list
         |> Day7Task1.getMedian

Day7Task1.calcNeededFuelList(list, median - 10..median + 10)
|> Enum.min_by(fn {_, x} -> x end)
|> elem(1)
|> IO.inspect


# Task 2
Day7Task2.calcNeededFuelList(list, Enum.min(list)..Enum.max(list))
|> Enum.min_by(fn {_, x} -> x end)
|> elem(1)
|> round
|> IO.inspect






