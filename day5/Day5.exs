defmodule Day5Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
    |> Enum.map(&Line.init(&1))
  end
end


defmodule Field do

  def init({x, y}) do
    for _ <- 0..y, do: for _ <- 0..x, do: 0
  end

  def increasePoint(field, {x, y} = point) do
    value = getCounter(field, point)
    List.replace_at(field, y, List.replace_at(Enum.at(field, y), x, value + 1))
  end

  def getCounter(field, {x, y}) do
    Enum.at(field, y)
    |> Enum.at(x)
  end
end

defmodule Line do
  def init(stringRow) do
    [p1 | [p2]] = stringRow
                  |> String.split("->")
                  |> Enum.map(
                       fn aString ->
                         [xS | [xY]] = String.split(aString, ",")
                         {
                           String.to_integer(String.trim(xS)),
                           String.to_integer(String.trim(xY))
                         }
                       end
                     )
    {p1, p2}
  end

  def toPoints({{x, y1}, {x, y2}}) do
    y1..y2
    |> Enum.map(fn y -> {x, y} end)
  end
  def toPoints({{x1, y}, {x2, y}}) do
    x1..x2
    |> Enum.map(fn x -> {x, y} end)
  end
  def toPoints(_) do
    []
  end

  def toPointsTask2({{x, y1}, {x, y2}}) do
    y1..y2
    |> Enum.map(fn y -> {x, y} end)
  end
  def toPointsTask2({{x1, y}, {x2, y}}) do
    x1..x2
    |> Enum.map(fn x -> {x, y} end)
  end
  def toPointsTask2({{x1, y1}, {x2, y2}}) when y1 > y2 do
    x1..x2
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> {x, y1 - i} end)
  end
  def toPointsTask2({{x1, y1}, {x2, _}}) do
    x1..x2
    |> Enum.with_index()
    |> Enum.map(fn {x, i} -> {x, y1 + i} end)
  end
end


# Task1
lines = Day5Task1.readInput("input1.txt")
        |> Enum.map(&Line.toPoints(&1))

{maxX, _} = lines
            |> Enum.concat()
            |> Enum.max_by(fn {x, _} -> x end)

{_, maxY} = lines
            |> Enum.concat()
            |> Enum.max_by(fn {_, y} -> y end)

field = Field.init({maxX, maxY})
filedFiled = lines
             |> Enum.concat()
             |> Enum.reduce(
                  field,
                  fn point, field ->
                    Field.increasePoint(field, point)
                  end
                )

filedFiled
|> Enum.concat()
|> Enum.filter(fn x -> x >= 2  end)
|> length
|> IO.inspect()

# Task 2
lines = Day5Task1.readInput("input1.txt")
        |> Enum.map(&Line.toPointsTask2(&1))

{maxX, _} = lines
            |> Enum.concat()
            |> Enum.max_by(fn {x, _} -> x end)

{_, maxY} = lines
            |> Enum.concat()
            |> Enum.max_by(fn {_, y} -> y end)

field = Field.init({maxX, maxY})
filedFiled = lines
             |> Enum.concat()
             |> Enum.reduce(
                  field,
                  fn point, field ->
                    Field.increasePoint(field, point)
                  end
                )

filedFiled
|> Enum.concat()
|> Enum.filter(fn x -> x >= 2  end)
|> length
|> IO.inspect()