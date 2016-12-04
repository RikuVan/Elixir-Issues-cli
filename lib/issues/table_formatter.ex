defmodule Issues.TableFormatter do
  alias Enum, as: E
  alias String, as: S

   @moduledoc """
    Generates a simple table with column widths based on longest
    items plus one space of padding. Change strings in format_for
    and separator for different table styling
    col separators: " || "
    header horizontal separator "-||-" & "-"
  """

  def format(data, headers) do
    cols = cols_from(data, headers)
    widths = widths_of(cols)
    format = format_for(widths)
    puts_one_line(format, headers)
    IO.puts(separator(widths))
    puts_in_cols(cols, format)
  end

  def cols_from(data, headers) do
    for header <- headers, do:
      for datum <- data, do:
        printable(datum[header])
  end

  def printable(item) do
    if is_binary(item),
      do: item,
      else: to_string(item)
  end

  def widths_of(cols) do
    for col <- cols, do:
      col |> E.map(&S.length/1) |> E.max
  end

  def puts_one_line(format, fields) do
    :io.format(format, fields)
  end

  def puts_in_cols(data_by_cols, format) do
    data_by_cols
     |> List.zip
     |> E.map(&Tuple.to_list/1)
     |> E.each(&puts_one_line(format, &1))
  end

  def format_for(widths) do
    E.map_join(widths, " || ", fn w -> "~-#{w}s" end) <> "~n"
  end

  def separator(widths) do
    E.map_join(widths, "-||-", fn width -> List.duplicate("-", width) end)
  end

end
