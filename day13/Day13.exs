defmodule Day13Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    [points, folds] = content
                      |> String.split("\n\n")
                      |> Enum.map(&String.split(&1, "\n"))

    [
      points
      |> Enum.map(
           fn string ->
             String.split(string, ",")
             |> Enum.map(&String.to_integer(&1))
           end
         ),
      folds
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn list -> Enum.at(list, 2) end)
      |> Enum.map(&String.split(&1, "="))
    ]
  end
end

defmodule Field do
  def new(maxX, maxY) do
    0..maxY
    |> Enum.reduce(
         Map.new,
         fn iY, field ->
           row = 0..maxX
                 |> Enum.reduce(
                      Map.new,
                      fn iX, row ->
                        Map.put(row, iX, [:false])
                      end
                    )
           Map.put(field, iY, row)
         end
       )
  end

  def init(field, listOfLists) do
    listOfLists
    |> Enum.reduce(
         field,
         fn [x, y], newField ->
           update(newField, x, y, [:true])
         end
       )
  end

  def get(field, x, y) do
    Map.get(field, y, Map.new)
    |> Map.get(x, [:false])
  end

  def getTopPart(field, until) do
    Map.keys(field)
    |> Enum.filter(fn y -> y < until  end)
    |> Enum.reduce(Map.new, fn y, map -> Map.put(map, y, Map.get(field, y)) end)
  end

  def getLeftPart(origField, until) do
    0..length(Map.keys(origField))
    |> Enum.reduce(
         Map.new,
         fn iY, field ->
           row = 0..until - 1
                 |> Enum.reduce(
                      Map.new,
                      fn iX, row ->
                        Map.put(row, iX, get(origField, iX, iY))
                      end
                    )
           Map.put(field, iY, row)
         end
       )
  end

  def getRightPart(origField, foldAt) do
    0..length(Map.keys(origField)) - 1
    |> Enum.reduce(
         Map.new,
         fn iY, field ->
           row = foldAt + 1..getXLength(origField) - 1
                 |> Enum.reduce(
                      Map.new,
                      fn iX, row ->
                        Map.put(row, iX - foldAt - 1, get(origField, iX, iY))
                      end
                    )
           Map.put(field, iY, row)
         end
       )
  end

  def getColumn(field, columnIndex) do
    field
    |> Map.keys()
    |> Enum.map(fn y -> get(field, columnIndex, y) end)
  end


  def update(field, x, y, newVal) do
    Map.put(field, y, Map.put(Map.get(field, y, Map.new), x, newVal))
  end

  def performFold(field, ["y", foldAt]) do
    newField = getTopPart(field, foldAt)
    0..getXLength(field) - 1
    |> Enum.reduce(
         newField,
         fn columnIndex, newField ->
           foldColumn(field, newField, columnIndex, foldAt)
         end
       )
  end

  def performFold(field, ["x", foldAt]) do
    newField = getRightPart(field, foldAt)
    0..length(Map.keys(field)) - 1
    |> Enum.reduce(
         newField,
         fn rowIndex, newField ->
           foldRow(field, newField, rowIndex, foldAt)
         end
       )
  end

  def getXLength(field) do
    Map.get(field, 0)
    |> Map.keys()
    |> length
  end

  def foldRow(origField, rightField, rowIndex, foldAt) do
    0..foldAt - 1
    |> Enum.reduce(
         rightField,
         fn iX, rightField ->
           update(
             rightField,
             iX,
             rowIndex,
             (get(rightField, iX, rowIndex) ++ get(origField, (foldAt - (iX + 1)), rowIndex))
           )
         end
       )
  end

  def foldColumn(origField, topField, columnIndex, foldAt) do
    column = getColumn(origField, columnIndex)
    foldAt - 1..(foldAt - (length(column) - 1 - foldAt))
    |> Enum.reduce(
         topField,
         fn iY, topField ->
           update(
             topField,
             columnIndex,
             iY,
             (get(topField, columnIndex, iY) ++ Enum.at(column, (foldAt - iY) + foldAt))
           )
         end
       )
  end

  def count(field) do
    0..length(Map.keys(field)) - 1
    |> Enum.reduce(
         0,
         fn rowIndex, acc ->
           acc + countRow(field, rowIndex)
         end
       )
  end

  def draw(field) do
    0..length(Map.keys(field)) - 1
    |> Enum.map(&printRow(field, &1))
    |> Enum.each(&IO.puts(&1))
    IO.puts("")
    field
  end

  def countRow(field, rowIndex) do
    0..getXLength(field) - 1
    |> Enum.map(&get(field, &1, rowIndex))
    |> Enum.map(&Enum.any?(&1))
    |> Enum.map(fn x -> if x, do: 1, else: 0 end)
    |> Enum.sum()
  end

  def printRow(field, rowIndex) do
    0..getXLength(field) - 1
    |> Enum.map(&get(field, &1, rowIndex))
    |> Enum.map(&Enum.any?(&1))
    |> Enum.map(fn x -> if x, do: "#", else: "." end)
    |> Enum.join
  end
end

defmodule Day13Task2 do
  # dose not really work...
end

# Task 1
[points, folds] = Day13Task1.readInput("testData2.txt")
[firstType, firstFoldAt] = Enum.at(folds, 0)

maxX = points
       |> Enum.map(&Enum.at(&1, 0))
       |> Enum.max
maxY = points
       |> Enum.map(&Enum.at(&1, 1))
       |> Enum.max

IO.inspect([firstType, String.to_integer(firstFoldAt)])

field = Field.new(maxX, maxY)
        |> Field.draw()
        |> Field.init(points)
field
|> Field.draw()
|> Field.performFold([firstType, String.to_integer(firstFoldAt)])
#|> Field.draw()
#|> Field.performFold(["y", 3])
|> IO.inspect
                           #|> Field.performFold(["x", 5])
#|> IO.inspect
|> Field.draw()
|> Field.count()
|> IO.inspect

# Task 2
[points, folds] = Day13Task1.readInput("input1.txt")

maxX = points
       |> Enum.map(&Enum.at(&1, 0))
       |> Enum.max
maxY = points
       |> Enum.map(&Enum.at(&1, 1))
       |> Enum.max
field = Field.new(maxX, maxY)
        #|> Field.draw()
        |> Field.init(points)
Enum.reduce(
  folds,
  field,
  fn [type, foldAt], field ->
    Field.getXLength(field) |> IO.inspect
    Field.performFold(field, [type, String.to_integer(foldAt)])
  end
)
|> Field.draw()



