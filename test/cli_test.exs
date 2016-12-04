defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_into_ascending_order: 1]

  test ":help returned by option parsing with -h and -help options" do
    assert parse_args(["-h", "help maybe?"]) == :help
    assert parse_args(["-help", "help maybe?"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "count is defaulted if two args given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "sorts issues in ascending order" do
    result = sort_into_ascending_order(
      fake_created_at_list(["c", "a", "b"])
    )
    issues = for issue <- result, do:
      Map.get(issue, "created_at")
    assert issues == ~w{a b c}
  end

  defp fake_created_at_list(values) do
    for value <- values, do:
      %{"created_at" => value, "other_date": "xxx"}
  end

end
