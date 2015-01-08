defmodule Eutils do

  def input_to_number(input), do: input |> String.strip 
                                        |> Float.parse 
                                        |> elem(0)

  def split_line(line), do: line |> String.split(",")
  
end
