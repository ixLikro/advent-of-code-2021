defmodule Day8Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "|"))
    |> Enum.map(
         fn [input, output] ->
           {parseString(input), parseString(output)}
         end
       )
  end

  defp parseString(string) do
    String.split(string, " ")
    |> Enum.filter(fn x -> x != "" end)
  end

  def countUniqueOutput({_, output}) do
    output
    |> Enum.filter(
         fn x -> String.length(x) == 2 || String.length(x) == 4 || String.length(x) == 3 || String.length(x) == 7 end
       )
    |> length
  end

end

defmodule Day8Task2 do

  def getA({input, _}) do
    input
    |> Enum.filter(fn x -> String.length(x) == 2 || String.length(x) == 3 end) # get 1 and 7
    |> subtractStrings
    |> hd
  end

  def getE({input, _}) do
    result = input
             |> Enum.filter(fn x -> String.length(x) == 6 end) # get 0, 6 and 9
      #|> IO.inspect
             |> Enum.map(&String.graphemes(&1))
    firstSub = filterByFrequency(result, 3)
    Map.keys(Enum.frequencies(Enum.concat(firstSub))) -- String.graphemes(
      hd(Enum.filter(input, fn x -> String.length(x) == 4 end))
    )
    |> hd
  end

  def getB({input, _}) do
    input
    |> Enum.map(&String.graphemes(&1))
    |> Enum.concat()
    |> Enum.frequencies()
    |> Map.to_list
    |> Enum.filter(fn {_, number} -> number == 6 end)
    |> hd
    |> elem(0)
  end

  def getC({input, _}, e) do
    result = input
             |> Enum.filter(fn x -> String.length(x) == 5 end) # get 2, 3 and 5
             |> Enum.map(&String.graphemes(&1))
    filterByFrequency(result, 3)
    |> Enum.map(&Enum.filter(&1, fn x -> x != e end))
    |> Enum.filter(fn x -> length(x) == 1 end)
    |> hd
    |> hd
  end

  def getF({input, _}, c) do
    result = input
             |> Enum.filter(fn x -> String.length(x) == 2 end) # get 1
             |> Enum.map(&String.graphemes(&1))
             |> hd
             |> Enum.filter(fn x -> x != c end)
             |> hd
  end

  def getG({input, _}, a, b, c, e, f) do
    zero = input
           |> Enum.filter(fn x -> String.length(x) == 6 end) # get 0, 6 and 9
           |> Enum.map(&String.graphemes(&1))
           |> Enum.filter(fn x -> Enum.member?(x, b) && Enum.member?(x, c) && Enum.member?(x, e) end)
           |> hd
    hd(zero -- [a, b, c, e, f])
  end

  def getD({input, _}, a, b, c, e, f, g) do
    eight = input
            |> Enum.filter(fn x -> String.length(x) == 7 end) # get 8
            |> Enum.map(&String.graphemes(&1))
            |> hd
    hd(eight -- [a, b, c, e, f, g])
  end

  def getMapping(oneRow) do
    a = oneRow
        |> Day8Task2.getA()
    e = oneRow
        |> Day8Task2.getE()
    b = oneRow
        |> Day8Task2.getB()
    c = oneRow
        |> Day8Task2.getC(e)
    f = oneRow
        |> Day8Task2.getF(c)
    g = oneRow
        |> Day8Task2.getG(a, b, c, e, f)
    d = oneRow
        |> Day8Task2.getD(a, b, c, e, f, g)
    Map.new()
    |> Map.put(a, "a")
    |> Map.put(b, "b")
    |> Map.put(c, "c")
    |> Map.put(d, "d")
    |> Map.put(e, "e")
    |> Map.put(f, "f")
    |> Map.put(g, "g")
  end

  def convert(mapping, {_, output}) do
    output
    |> Enum.map(
         fn x ->
           list = String.graphemes(x)
           Enum.reduce(
             list,
             [],
             fn y, newList ->
               List.insert_at(newList, 0, Map.get(mapping, y))
             end
           )
         end
       )
    # |> Enum.join
  end

  def digitsToNumber(list) do
    case Enum.sort(list)
         |> Enum.join do
      "abcefg" -> 0
      "cf" -> 1
      "acdeg" -> 2
      "acdfg" -> 3
      "bcdf" -> 4
      "abdfg" -> 5
      "abdefg" -> 6
      "acf" -> 7
      "abcdefg" -> 8
      _ -> 9
    end
  end

  defp filterByFrequency(listOfLists, max) do
    frequencies = listOfLists
                  |> Enum.concat()
                  |> Enum.frequencies()
    listOfLists
    |> Enum.map(&Enum.filter(&1, fn x -> Map.get(frequencies, x) < max end))
  end

  defp subtractStrings([str1, str2]) do
    list1 = String.graphemes(str1)
    list2 = String.graphemes(str2)
    {long, short} = if length(list1) >= length(list2), do: {list1, list2}, else: {list2, list1}
    long -- short
  end

end

# Task 1
Day8Task1.readInput("input1.txt")
|> Enum.map(&Day8Task1.countUniqueOutput(&1))
|> Enum.sum
|> IO.inspect

# Task2
Day8Task1.readInput("input1.txt")
|> Enum.map(
     fn oneRow ->
       mapping = Day8Task2.getMapping(oneRow)
       Day8Task2.convert(mapping, oneRow)
     end
   )
|> Enum.map(
     fn x ->
       x
       |> Enum.map(&Day8Task2.digitsToNumber(&1))
       |> Enum.join
       |> String.to_integer()
     end
   )
|> Enum.sum
|> IO.inspect












