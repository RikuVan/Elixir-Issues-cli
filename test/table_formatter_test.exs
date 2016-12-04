defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def test_data do
    [
      [c1: "r1 c1", c2: "r1 c2", c3: "r1 c3", c4: "r1++++c4"],
      [c1: "r2 c1", c2: "r2 c2", c3: "r2 c3", c4: "r2++c4"],
      [c1: "r3 c1", c2: "r3 c2", c3: "r3 c3", c4: "r3++++++c4"],
    ]
  end

  def test_headers, do: [:c1, :c2, :c4]

  def split_into_three_cols do
    TF.cols_from(test_data, test_headers)
  end

  test "splits into columns" do
    cols = split_into_three_cols
    assert length(cols) === length(test_headers)
    assert List.first(cols) === ["r1 c1", "r2 c1", "r3 c1"]
    assert List.last(cols) === ["r1++++c4", "r2++c4", "r3++++++c4"]
  end

  test "col widths" do
    widths = TF.widths_of(split_into_three_cols)
    assert widths === [5, 5, 10]
  end

  test "correct format string returned" do
    assert TF.format_for([9, 10, 11]) === "~-9s || ~-10s || ~-11s~n"
  end

  test "table output is correct" do
    result = capture_io fn ->TF.format(test_data, test_headers) end
    assert result ==
    "c1    || c2    || c4        \n------||-------||-----------\nr1 c1 || r1 c2 || r1++++c4  \nr2 c1 || r2 c2 || r2++c4    \nr3 c1 || r3 c2 || r3++++++c4\n"
  end

end