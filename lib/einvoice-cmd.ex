defmodule Einvoice.CMD do
  import Eutils, only: [to_number: 1, split_line: 1]
  import Einvoice
  import MultiDef

  @default_vat 20
  @default_options %{ :vat => @default_vat, 
                      :input_file => nil }

  defp parse_options(args), do: args |> OptionParser.parse(
                                  switches: [help: :boolean, input_file: :string, vat: :float], 
                                  aliases: [h: :help, i: :input_file])

  mdef _parse_args do
    {[help: true], _, _}  -> :help
    {[], [], []}          -> :help
    {[], args, []}        -> { @default_options, args}
    {opts, args, []}      -> { Enum.into(opts, @default_options), args }
  end

  def parse_args(args), do: args |> parse_options |> _parse_args

  defp parse_line([description, unit_price, qty]), do: [description, to_number(unit_price), to_number(qty)]
  defp parse_line([_]), do: [:empty_line, 0, 0]

  defp display_line(description, unit_price, qty, l_total) do
    [description_s, unit_price_s, qty_s, l_total_s] = :io_lib.format("~30.. s~10.2. f~10.2. f~10.2. f", [description, unit_price, qty, l_total])
    IO.puts "#{description_s} \t#{unit_price_s} \t#{qty_s} \t#{l_total_s}"
    l_total
  end

  defp process_line([:empty_line, _, _]), do: 0.0
  defp process_line([description, unit_price, qty]), do: display_line(description, unit_price, qty, line_total(unit_price, qty))

  defp process_lines([], acc), do: acc
  defp process_lines([head|tail], acc), do: process_lines(tail, head |> split_line |> parse_line |> process_line |> +(acc))

  defp display_totals(amount, vat, vat_rate, total) do
    [amount_l, vat_l, total_l] = :io_lib.format("~30.. s~30.. s~30.. s", ["Amount:", "VAT (#{vat_rate}%):", "TOTAL:"])
    [amount_s, vat_s, total_s] = :io_lib.format("~42.2. f~42.2. f~42.2. f", [amount, vat, total])
    IO.puts String.duplicate("-", 74)
    IO.puts "#{amount_l}\t#{amount_s}"
    IO.puts "#{vat_l}\t#{vat_s}\n"
    IO.puts "#{total_l}\t#{total_s}"
  end

  defp _process(nil, vat_rate, [amount]), do: IO.puts(add_vat(amount |> to_number, vat_rate))
  defp _process(file, vat_rate, []) do
    amount = file |> File.read! 
                  |> String.split("\n") 
                  |> process_lines(0.0)
    File.close file
    vat = calc_vat(amount, vat_rate)
    total = amount + vat
    display_totals(amount, vat, vat_rate, total)
    System.halt(0)
  end

  def process({options, args}), do: _process(options[:input_file], options[:vat] || @default_vat, args)
  def process(:help) do
    IO.puts """
      Usage:
        einvoice [amount]

      Options:
        -h, [--help]        # Show this help message and quit.
        -i, [--input_file]  # Create an invoice from supplied row data in CSV format. 
        --vat               # Set the VAT rate (default is 20%)


      Description:
        If `amount` is specified, calcualtes and prints out the VAT on that amount. 
        If an input CSV file is specified, reads the line entries and prints out an invoice. 
    """
    System.halt(0)
  end

  def main(args) do
    args |> parse_args |> process
  end
 
end
