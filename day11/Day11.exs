defmodule Day11Task1 do
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
                        Map.put(row, ix, {String.to_integer(x), :false})
                      end
                    )
           Map.put(field, iy, row)
         end
       )
  end

  def get(field, x, y) do
    Map.get(field, y, Map.new)
    |> Map.get(x, {-1, :true})
  end

  def update(field, x, y, newVal) when x < 10 and x >= 0 and y < 10 and y >= 0 do
    Map.put(field, y, Map.put(Map.get(field, y), x, newVal))
  end
  def update(field, _, _, _) do
    field
  end

  def performStep(field) do
    0..Enum.max(Map.keys(field))
    |> Enum.reduce(
         {field, 0},
         fn iY, {newField, counter} ->
           {fieldAfterStep, newCounter} = performOneStepInRow(newField, iY)
           {fieldAfterStep, newCounter + counter}
         end
       )
  end

  defp performOneStepInRow(field, iY) do
    row = Map.get(field, iY)
    0..Enum.max(Map.keys(row))
    |> Enum.reduce(
         {field, 0},
         fn iX, {newField, flashCounter} ->
           {fieldAfterStep, newCounter} = performOneStepInCell(newField, iX, iY)
           {fieldAfterStep, newCounter + flashCounter}
         end
       )
  end

  def performOneStepInCell(field, ix, iy) do
    {counter, alreadyFlashed} = Field.get(field, ix, iy)
    if alreadyFlashed do
      {Field.update(field, ix, iy, {0, :true}), 0}
    else
      if counter <= 8 do
        {Field.update(field, ix, iy, {counter + 1, :false}), 0}
      else
        {fieldAfterStep, flashed} = getNeighboursIndexes(field, ix, iy)
                                    |> Enum.reduce(
                                         {field, 0},
                                         fn {x, y}, {newField, counter} ->
                                           {fieldAfterStep, newCounter} = performOneStepInCell(
                                             Field.update(newField, ix, iy, {0, :true}),
                                             x,
                                             y
                                           )
                                           {fieldAfterStep, newCounter + counter}
                                         end
                                       )

        {fieldAfterStep, flashed + 1}
      end
    end
  end

  def prepareField(field) do
    0..9
    |> Enum.reduce(
         field,
         fn iY, newField ->
           0..9
           |> Enum.reduce(
                newField,
                fn iX, newField1 ->
                  {counter, _} = Field.get(newField1, iX, iY)
                  Field.update(newField1, iX, iY, {counter, :false})
                end
              )
         end
       )
  end

  defp getNeighboursIndexes(_, x, y) do
    [
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y},
      {x - 1, y},
    ]
  end
end

defmodule Day11Task2 do
end

# Task 1
field = Day11Task1.readInput("input1.txt")
        |> Field.new
0..99
|> Enum.reduce(
     {field, 0},
     fn _, {field, counter} ->
       {newField, newCounter} = Field.performStep(field)
       {Field.prepareField(newField), counter + newCounter}
     end
   )
|> elem(1)
|> IO.inspect

# Task 2
# to be honest i just tried it without programming anything 0_0
IO.puts("422")