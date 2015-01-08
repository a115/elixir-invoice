defmodule Eutils do

  def to_number(input), do: input |> String.strip |> Float.parse |> elem(0)

  def split_line(line), do: line |> String.split(",") |> Enum.map(&String.strip/1)
  
end
