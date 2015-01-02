elixir-invoice
==============

Elixir library for invoicing and calculating VAT

This package contains a module (Einvoice) and a command-line utility (Einvoice.CMD) used to calculate and format invoice data and VAT. 

The main module comes with a full suite of unit tests, which you can run with `mix test`

You can compile the command-line utility with `mix escript.build` and execute with `./einvoice` When invoked without parameters, the utility will print a help message describing its intended usage and the supported parameters. 
