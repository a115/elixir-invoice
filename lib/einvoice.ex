defmodule Einvoice do

  defp _add_up([], acc), do: acc
  defp _add_up([head|tail], acc), do: _add_up(tail, head + acc)
  
  @spec add_up(list()) :: number()
  def add_up(list), do: _add_up(list, 0)

  @spec calc_vat(number(), number()) :: number()
  def calc_vat(total, vat \\ 20), do: vat * total / 100

  @spec add_vat(number(), number()) :: number()
  def add_vat(total, vat \\ 20), do: total + calc_vat(total, vat)

  @spec line_total(number(), number()) :: number()
  def line_total(unit_price, qty), do: unit_price * qty

end
