defmodule Day3Task1 do

  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
  end

  def handleColumns(list) do
    0..String.length(hd(list)) -1
    |> Enum.map(fn i -> doCountColumn(list, i) end)
  end

  def convertCountsToBinary(listOfCounts) do
    listOfCounts
    |> Enum.map(&convertToBinary(&1))
  end

  def invert(binaryAsString) do
    binaryAsString
    |> Enum.map(fn
      "0" -> "1"
      "1" -> "0"
    end)
  end

  def convert(list) do
    list
    |> Integer.parse(2)
    |> elem(0)
  end

  def doCountColumn(list, columnIndex) do
    list
    |> Enum.reduce({0,0}, fn binNumberAsString, {zeroCount, oneCount} ->
      if String.at(binNumberAsString, columnIndex) == "1" do
        {zeroCount, oneCount+1}
      else
        {zeroCount+1, oneCount}
      end
    end)
  end

  defp convertToBinary({zeroCount, oneCount}) when zeroCount > oneCount do
    "0"
  end
  defp convertToBinary(_) do
    "1"
  end
end

defmodule Day3Task2 do
  def filterByColumn(list, columnCount, shouldBe) do
    Enum.filter(list, fn item ->
      if String.at(item, columnCount) == shouldBe do
          true
        else
          false
      end
    end)
  end

  def getOneValue(list, decideFun) do
    doGetOneValue(list, 0, decideFun)
  end

  defp doGetOneValue([head | []], _, _) do head end
  defp doGetOneValue(list, columnCount, decideFun) do
    shouldBe = Day3Task1.doCountColumn(list, columnCount)
    |> decideFun.()
    doGetOneValue(filterByColumn(list, columnCount, shouldBe), columnCount + 1, decideFun)
  end

  def prefer0({zeroCount, oneCount}) do
    if zeroCount > oneCount do
      "1"
    else if zeroCount == oneCount, do: "0", else: "0"
    end
  end

  def prefer1({zeroCount, oneCount}) do
    if zeroCount > oneCount do
      "0"
    else if zeroCount == oneCount, do: "1", else: "1"
    end
  end
end

# Task1
first = Day3Task1.readInput("input1.txt")
|> Day3Task1.handleColumns()
|> Day3Task1.convertCountsToBinary()

second = Day3Task1.invert(first)
|> Enum.join("")
|> Day3Task1.convert

first = first
|> Enum.join("")
|> Day3Task1.convert

IO.inspect(first * second)

# Task2
firstT2 = Day3Task1.readInput("input1.txt")
|> Day3Task2.getOneValue(&Day3Task2.prefer0/1)
|> Day3Task1.convert

secondT2 = Day3Task1.readInput("input1.txt")
|> Day3Task2.getOneValue(&Day3Task2.prefer1/1)
|> Day3Task1.convert

IO.inspect(firstT2 * secondT2)
