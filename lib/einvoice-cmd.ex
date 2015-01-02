defmodule Einvoice.CMD do
  import Einvoice

  def input_to_number(input), do: elem(Float.parse(String.strip(input)), 0)

  def parse_args(args) do
    options = OptionParser.parse(args, 
                                  switches: [help: :boolean, input_file: :string], 
                                  aliases: [h: :help, i: :input_file])
    case options do
      {[help: true], _, _} -> :help
      {[input_file: file], _, _} -> [:read_file, file]
      {_, [amount], _} -> [amount |> input_to_number, 20.0]
      {_, [amount, vat], _} -> [amount |> input_to_number, vat |> input_to_number]
      _ -> :help
    end
  end

  def parse_line(line) do
    case String.split(line, ",") do
      [description, unit_price, qty] -> [description, input_to_number(unit_price), input_to_number(qty)]
      [_] -> [:empty_line, 0, 0]
    end
  end

  def display_line(description, unit_price, qty, l_total) do
    [description_s, unit_price_s, qty_s, l_total_s] = :io_lib.format("~30.. s~10.2. f~10.2. f~10.2. f", [description, unit_price, qty, l_total])
    IO.puts "#{description_s} \t#{unit_price_s} \t#{qty_s} \t#{l_total_s}"
    l_total
  end

  def process_lines([]), do: 0
  def process_lines([head|tail]) do
    case parse_line(head) do
      [:empty_line, _, _] -> 0
      [description, unit_price, qty] -> display_line(description, unit_price, qty, line_total(unit_price, qty))
    end + process_lines(tail)
  end

  def display_totals(amount, vat, total) do
    [amount_l, vat_l, total_l] = :io_lib.format("~30.. s~30.. s~30.. s", ["Amount:", "VAT (20%):", "TOTAL:"])
    [amount_s, vat_s, total_s] = :io_lib.format("~42.2. f~42.2. f~42.2. f", [amount, vat, total])
    IO.puts String.duplicate("-", 74)
    IO.puts "#{amount_l}\t#{amount_s}"
    IO.puts "#{vat_l}\t#{vat_s}\n"
    IO.puts "#{total_l}\t#{total_s}"
  end

  def process([:read_file, file]) do
    amount = file |> File.read! 
                  |> String.split("\n") 
                  |> process_lines
    File.close file
    vat = calc_vat(amount)
    total = amount + vat
    display_totals(amount, vat, total)
    System.halt(0)
  end
  def process([amount, vat]) do
    IO.puts add_vat(amount, vat)
  end
  def process(:help) do
    IO.puts """
      Usage:
        einvoice amount [vat]

      Options:
        -h, [--help]        # Show this help message and quit.
        -i, [--input_file]  # Create an invoice from supplied row data in CSV format. 

      Description:
        Calcualtes VAT for an invoice. 
    """
    System.halt(0)
  end

  def main(args) do
    args |> parse_args |> process
  end
 
end

