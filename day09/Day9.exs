defmodule Day9Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
  end

end

defmodule Field do
  def new(listOfStrings) do
    0..length(listOfStrings) - 1
    |> Enum.reduce(
         Map.new(),
         fn iy, field ->
           row = Enum.at(listOfStrings, iy)
                 |> String.graphemes()
                 |> Enum.with_index()
                 |> Enum.reduce(
                      Map.new(),
                      fn {x, ix}, row ->
                        Map.put(row, ix, String.to_integer(x))
                      end
                    )
           Map.put(field, iy, row)
         end
       )
  end

  def get(field, x, y) do
    Map.get(field, y, Map.new)
    |> Map.get(x, 10)
  end

  def getLowPoints(field) do
    0..Enum.max(Map.keys(field))
    |> Enum.map(&getLowPointsInRow(field, &1))
    |> Enum.concat()
  end

  defp getLowPointsInRow(field, iY) do
    row = Map.get(field, iY)
    0..Enum.max(Map.keys(row))
    |> Enum.reduce(
         [],
         fn iX, acc ->
           if getNeighbours(field, iX, iY)
              |> Enum.min > Field.get(field, iX, iY) do
             List.insert_at(acc, 0, {iX, iY, Field.get(field, iX, iY)})
           else
             acc
           end
         end
       )
  end

  defp getNeighbours(field, x, y) do
    [
      Field.get(field, x - 1, y),
      Field.get(field, x + 1, y),
      Field.get(field, x, y - 1),
      Field.get(field, x, y + 1)
    ]
  end
end

defmodule FieldT2 do
  def getBasinCount(field, x, y) do
    doGetBasinCount(field, x, y, Map.new(), 0)
    |> Map.keys()
    |> length
  end

  def doGetBasinCount(field, x, y, markedPoints, compareValue) do
    value = Field.get(field, x, y)
    if value > 8 or compareValue > value or Map.get(markedPoints, {x, y}, :false) do
      markedPoints
    else
      markedPoints = Map.put(markedPoints, {x, y}, True)
      markedPoints = doGetBasinCount(field, x - 1, y, markedPoints, value)
      markedPoints = doGetBasinCount(field, x + 1, y, markedPoints, value)
      markedPoints = doGetBasinCount(field, x, y - 1, markedPoints, value)
      markedPoints = doGetBasinCount(field, x, y + 1, markedPoints, value)
      markedPoints
    end
  end

end


# Task 1
Day9Task1.readInput("input1.txt")
|> Field.new
|> Field.getLowPoints
|> Enum.map(&elem(&1, 2))
|> Enum.map(fn x -> x + 1 end)
|> Enum.sum
|> IO.inspect

# Task 2
field = Day9Task1.readInput("input1.txt")
        |> Field.new
basins = field
         |> Field.getLowPoints
         |> Enum.map(
              fn {x, y, _} ->
                FieldT2.getBasinCount(field, x, y)
              end
            )
         |> Enum.sort
IO.inspect(Enum.at(basins, -1) * Enum.at(basins, -2) * Enum.at(basins, -3))
















