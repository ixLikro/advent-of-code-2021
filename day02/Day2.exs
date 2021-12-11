defmodule Day2Task1 do

  def readInput(filename) do
    {:ok, content} = File.read("data/#{filename}")
    content
    |> String.split("\n")
    |> Enum.map(fn line-> String.split(line, " ") end)
  end

  def sumCommands(listOfLists) do
    listOfLists
    |> Enum.reduce({0, 0}, fn [command | [amount]], acc ->
      addOneCommand(command, String.to_integer(amount), acc)
    end)
  end

  defp addOneCommand("forward", amount, {horizontalPos, depth}) do
    {horizontalPos + amount, depth}
  end
  defp addOneCommand("down", amount, {horizontalPos, depth}) do
    {horizontalPos, depth + amount}
  end
  defp addOneCommand("up", amount, {horizontalPos, depth}) do
    {horizontalPos, depth - amount}
  end
end

defmodule Day2Task2 do
  def sumCommands(listOfLists) do
    listOfLists
    |> Enum.reduce({0, 0, 0}, fn [command | [amount]], acc ->
      addOneCommand(command, String.to_integer(amount), acc)
    end)
  end

  defp addOneCommand("forward", amount, {horizontalPos, depth, aim}) do
    {horizontalPos + amount, depth + aim * amount, aim}
  end
  defp addOneCommand("down", amount, {horizontalPos, depth, aim}) do
    {horizontalPos, depth, aim + amount}
  end
  defp addOneCommand("up", amount, {horizontalPos, depth, aim}) do
    {horizontalPos, depth, aim - amount}
  end
end


Day2Task1.readInput("input1.txt")
|> Day2Task1.sumCommands
|> then(fn {horizontalPos, depth} -> horizontalPos * depth end)
|> IO.inspect()

Day2Task1.readInput("input1.txt")
|> Day2Task2.sumCommands
|> then(fn {horizontalPos, depth, _} -> horizontalPos * depth end)
|> IO.inspect()