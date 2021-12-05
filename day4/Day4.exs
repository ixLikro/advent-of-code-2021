defmodule Bingo do
  def init(listOfRows) do
    listOfRows
    |> Enum.map(
         fn stringRow ->
           String.split(stringRow, " ")
           |> Enum.filter(fn number -> number != "" end)
           |> Enum.map(fn number -> {String.to_integer(number), :notMarked} end)
         end
       )
  end

  def markNumber(bingo, numberToMark) do
    bingo
    |> Enum.map(
         fn row ->
           row
           |> Enum.map(
                fn {number, marked} ->
                  if number == numberToMark, do: {number, :marked}, else: {number, marked}
                end
              )
         end
       )
  end

  def isBingo?(bingo, bingoSize) do
    Enum.any?([isBingoRow?(bingo, bingoSize), isBingoColumn?(bingo, bingoSize)])
  end

  def getNumbers(bingo, marked) do
    Enum.concat(bingo)
    |> Enum.filter(fn {_, isMarked} -> isMarked == marked end)
    |> Enum.map(fn {number, _} -> number end)
  end

  defp isBingoRow?(bingo, bingoSize) do
    # check row
    bingo
    |> Enum.map(&countMarkedRow(&1))
    |> Enum.map(fn count -> if count >= bingoSize, do: true, else: false end)
    |> Enum.any?()
  end

  defp isBingoColumn?(bingo, bingoSize) do
    0..bingoSize - 1
    |> Enum.map(&getColumn(bingo, &1))
    |> Enum.map(&countMarkedRow(&1))
    |> Enum.map(fn count -> if count >= bingoSize, do: true, else: false end)
    |> Enum.any?()
  end

  defp countMarkedRow(listOfNumber) do
    listOfNumber
    |> Enum.reduce(
         0,
         fn
           {_, :marked}, acc -> acc + 1
           _, acc -> acc
         end
       )
  end

  defp getColumn(bingo, columnIndex) do
    bingo
    |> Enum.map(&Enum.at(&1, columnIndex))
  end
end

defmodule Day4Task1 do
  def readInput(filename, bingoSize) do
    {:ok, content} = File.read("data/#{filename}")
    [numbers | bingos] = content
                         |> String.split("\n")
    bingos = Enum.filter(bingos, fn row -> row != "" end)
    numbers = numbers
              |> String.split(",")
              |> Enum.map(&String.to_integer(&1))
    {numbers, Enum.chunk_every(bingos, bingoSize)}
  end

  def getWinnerBingo(numbers, bingos, bingoSize) do
    doCheckBingos(numbers, bingos, bingoSize, {nil, 0})
  end

  defp doCheckBingos([number | tail], bingos, bingoSize, {nil, _}) do
    markedBingos = bingos
                   |> Enum.map(&Bingo.markNumber(&1, number))
    winnerBingo = markedBingos
                  |> Enum.map(&Bingo.isBingo?(&1, bingoSize))
                  |> Enum.with_index()
                  |> Enum.reduce(
                       nil,
                       fn {isWinner, index}, acc ->
                         if isWinner, do: Enum.at(markedBingos, index), else: acc
                       end
                     )
    doCheckBingos(tail, markedBingos, bingoSize, {winnerBingo, number})
  end
  defp doCheckBingos(_, _, _, winnerBingo) do
    winnerBingo
  end
end

defmodule Day4Task2 do
  def getLastWinnerBingo(numbers, bingos, bingoSize) do
    Enum.map(bingos, fn bingo ->
      doCheckOneBingo(numbers, bingo, bingoSize, {nil, 0, 0})
    end)
    |> Enum.max_by(fn {_, _, counter} -> counter end)
  end

  defp doCheckOneBingo([number | tail], bingo, bingoSize, {nil, _, counter}) do
    markedBingo = Bingo.markNumber(bingo, number)
    if Bingo.isBingo?(markedBingo, bingoSize) do
      {markedBingo, number, counter}
      else
      doCheckOneBingo(tail, markedBingo, bingoSize, {nil, -1, counter + 1})
    end
  end

end

bingoSize = 5

# Task1
{chosenNumbers, rawBingos} = Day4Task1.readInput("input1.txt", bingoSize)
bingos = rawBingos
         |> Enum.map(fn rawBingo -> Bingo.init(rawBingo) end)

{winnerBingo, winNumber} = Day4Task1.getWinnerBingo(chosenNumbers, bingos, bingoSize)
IO.inspect(
  (
    Bingo.getNumbers(winnerBingo, :notMarked)
    |> Enum.sum) * winNumber
)

#Task 2
{chosenNumbers, rawBingos} = Day4Task1.readInput("input1.txt", bingoSize)
bingos = rawBingos
         |> Enum.map(fn rawBingo -> Bingo.init(rawBingo) end)
{winnerBingo, winNumber, _} = Day4Task2.getLastWinnerBingo(chosenNumbers, bingos, bingoSize)
IO.inspect(
  (
    Bingo.getNumbers(winnerBingo, :notMarked)
    |> Enum.sum) * winNumber
)



