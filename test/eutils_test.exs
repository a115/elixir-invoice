defmodule EutilsTest do
  use ExUnit.Case

  import Eutils

  test "to_number parses int to float" do
    assert to_number("21") === 21.00
  end

  test "to_number parses float to float" do
    assert to_number("21.03") === 21.03
  end

  test "to_number isn't bothered by trailing spaces" do
    assert to_number("15  ") === 15.00
  end

  test "to_number isn't bothered by leading spaces" do
    assert to_number("  5") === 5.00
  end

  test "to_number handles negative numbers" do
    assert to_number("-3.14") === -3.14
  end

  test "split_line splits a line at commas and strips spaces" do
    assert split_line("one, two, three ") == ["one", "two", "three"]
  end

  test "split_line handles line without commas" do
    assert split_line("something else") == ["something else"]
  end

  test "split_line handles empty line" do
    assert split_line("") == [""]
  end

end
