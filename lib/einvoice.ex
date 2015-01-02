defmodule Einvoice do

  def add_up([]), do: 0
  def add_up([head|tail]), do: head + add_up(tail)

  @spec calc_vat(number(), number()) :: number()
  def calc_vat(total, vat \\ 20), do: vat * total / 100

  @spec add_vat(number(), number()) :: number()
  def add_vat(total, vat \\ 20), do: total + calc_vat(total, vat)

  @spec line_total(number(), number()) :: number()
  def line_total(unit_price, qty), do: unit_price * qty

end
