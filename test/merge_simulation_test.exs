defmodule MergeSimulationTest do
  use ExUnit.Case
  doctest MergeSimulation

  ## Testing high endian merge

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

  ## Testing little endian merge

  test "center little endian merge" do
    assert MergeSimulation.merge_list_little_endian([4, 3, 3, 2, 1]) == [4, 4, 2, 1]
  end

  test "left little endian merge" do
    assert MergeSimulation.merge_list_little_endian([3, 3, 2, 1]) == [4, 2, 1]
  end

  test "right little endian merge" do
    assert MergeSimulation.merge_list_little_endian([2, 1, 0, 0]) == [2, 1, 1]
  end

  test "no little endian merge" do
    assert MergeSimulation.merge_list_little_endian([4, 3, 2, 1, 0]) == [4, 3, 2, 1, 0]
  end
end
