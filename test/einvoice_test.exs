defmodule EinvoiceTest do
  use ExUnit.Case

  import Einvoice

  test "add_up correctly returns zero for empty list" do
    assert add_up([]) == 0
  end

  test "add_up correctly returns sum of integer items in non-empty list" do
    assert add_up([2,3,4,5,6,7]) == 27
  end

  test "calc_vat returns zero for zero amount" do
    assert calc_vat(0) == 0
  end

  test "calc_vat returns correct default (20%) vat for amount" do
    assert calc_vat(80) == 16
  end

  test "calc_vat returns correct vat with decimals" do
    assert calc_vat(81) == 16.2
  end

  test "calc_vat returns correct custom vat for amount" do
    assert calc_vat(70, 21.5) == 15.05
  end

  test "calc_vat returns zero when vat is 0%" do
    assert calc_vat(75, 0) == 0
  end

  test "add_vat returns correct amount with default (20%) vat" do
    assert add_vat(100) == 120
  end

  test "add_vat returns zero when amount is 0" do
    assert add_vat(0) == 0
  end

  test "add_vat returns correct amount with custom vat" do 
    assert add_vat(70, 18) == 82.6
  end

  test "add_vat returns same amount when vat is 0%" do
    assert add_vat(75, 0) == 75
  end

  test "line_total returns zero when quantity is 0" do
    assert line_total(15.2, 0) == 0
  end

  test "line_total returns zero when unit price is 0" do
    assert line_total(0, 3) == 0
  end

  test "line_total returns correct total for non-zero quantity and unit price" do
    # Can't check exactly because actual result is 45.599999999999994 for some reason
    assert_in_delta line_total(15.2, 3), 45.6, 0.0001
  end

end
