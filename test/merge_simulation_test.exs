defmodule MergeSimulationTest do
  use ExUnit.Case
  doctest MergeSimulation

  test "center merge list" do
    assert MergeSimulation.merge_list([2, 1, 1, 0]) == [2, 2, 0]
  end

  test "left merge list" do
    assert MergeSimulation.merge_list([1, 1, 0]) == [2, 0]
  end

  test "right merge list" do
    assert MergeSimulation.merge_list([2, 0, 0]) == [2, 1]
  end

  test "no merge" do
    assert MergeSimulation.merge_list([2, 1, 0]) == [2, 1, 0]
  end

end
