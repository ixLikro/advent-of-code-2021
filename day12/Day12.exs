defmodule Day12Task1 do
  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
  end
end

defmodule Graph do
  def new(listOfStrings) do
    map = listOfStrings
          |> Enum.map(&String.split(&1, "-"))
          |> Enum.reduce(
               Map.new,
               fn [a, b], map ->
                 aList = Map.get(map, a, [])
                 bList = Map.get(map, b, [])
                 Map.put(map, a, List.insert_at(aList, 0, b))
                 |> Map.put(b, List.insert_at(bList, 0, a))
               end
             )
    Map.keys(map)
    |> Enum.reduce(
         map,
         fn key, map ->
           conns = Map.get(map, key)
           Map.put(map, key, {conns, String.upcase(key) == key, 0})
         end
       )
  end

  def findSolutions(graph) do
    doHandleStep(graph, "start", ["start"], [])
    |> List.flatten()
    |> Enum.filter(fn node -> node == "end" end)
    |> length
  end

  defp doHandleStep(graph, node, currentWay, solutions) do
    if node == "end" do
      List.insert_at(solutions, 0, currentWay)
    else
      possibleConns = getPossibleConns(graph, node)
      newGraph = increaseCounter(graph, node)
      Enum.map(
        possibleConns,
        fn newNode -> result = doHandleStep(newGraph, newNode, currentWay ++ [newNode], solutions)
        end
      )
    end
  end

  defp increaseCounter(graph, node) do
    {conns, allowed, counter} = Map.get(graph, node)
    Map.put(graph, node, {conns, allowed, counter + 1})
  end

  def getPossibleConns(graph, node) do
    {conns, _, _} = Map.get(graph, node)
    Enum.reduce(
      conns,
      [],
      fn key, list ->
        {_, allowed, counter} = Map.get(graph, key)
        if allowed or (not allowed and counter == 0), do: List.insert_at(list, 0, key), else: list
      end
    )
  end
end

defmodule GraphT2 do
  def new(listOfStrings, allowedTwice) do
    map = listOfStrings
          |> Enum.map(&String.split(&1, "-"))
          |> Enum.reduce(
               Map.new,
               fn [a, b], map ->
                 aList = Map.get(map, a, [])
                 bList = Map.get(map, b, [])
                 Map.put(map, a, List.insert_at(aList, 0, b))
                 |> Map.put(b, List.insert_at(bList, 0, a))
               end
             )
    Map.keys(map)
    |> Enum.reduce(
         map,
         fn key, map ->
           conns = Map.get(map, key)
           Map.put(
             map,
             key,
             {
               conns,
               (if String.upcase(key) == key, do: 999999999999999, else: (if allowedTwice == key, do: 2, else: 1)),
               0
             }
           )
         end
       )
  end

  def findSolutions(graph) do
    doHandleStep(graph, "start", ["start"], [])
    |> List.flatten()
    |> Enum.join("")
    |> String.split("end")
  end

  defp doHandleStep(graph, node, currentWay, solutions) do
    if node == "end" do
      List.insert_at(solutions, 0, currentWay)
    else
      possibleConns = getPossibleConns(graph, node)
      newGraph = increaseCounter(graph, node)
      Enum.map(
        possibleConns,
        fn newNode -> result = doHandleStep(newGraph, newNode, currentWay ++ [newNode], solutions)
        end
      )
    end
  end

  defp increaseCounter(graph, node) do
    {conns, allowed, counter} = Map.get(graph, node)
    Map.put(graph, node, {conns, allowed, counter + 1})
  end

  def getPossibleConns(graph, node) do
    {conns, _, _} = Map.get(graph, node)
    Enum.reduce(
      conns,
      [],
      fn key, list ->
        {_, allowed, counter} = Map.get(graph, key)
        if allowed > counter, do: List.insert_at(list, 0, key), else: list
      end
    )
  end
end


defmodule Day12Task2 do
end

# Task 1
Day12Task1.readInput("input1.txt")
|> Graph.new
|> Graph.findSolutions
|> IO.inspect

input = Day12Task1.readInput("input1.txt")
graph = Day12Task1.readInput("input1.txt")
|> Graph.new()
|> Map.keys()
|> Enum.filter(fn key -> String.downcase(key) == key and String.length(key) < 3 end)
|> Enum.map(fn smallCave ->
  GraphT2.new(input, smallCave)
  |> GraphT2.findSolutions
end)
|> Enum.concat()
|> Enum.filter(fn x -> x != "" end)
|> Enum.into(HashSet.new)
|> HashSet.to_list()
|> length
|> IO.inspect
