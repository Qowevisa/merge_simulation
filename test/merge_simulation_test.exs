defmodule MergeSimulationTest do
  use ExUnit.Case
  doctest MergeSimulation

  ## Testing high endian merge

  test "center merge list" do
    assert MergeSimulation.merge_list([2, 1, 1, 0]) == {[2, 2, 0], :yes}
  end

  test "left merge list" do
    assert MergeSimulation.merge_list([1, 1, 0]) == {[2, 0], :yes}
  end

  test "right merge list" do
    assert MergeSimulation.merge_list([2, 0, 0]) == {[2, 1], :yes}
  end

  test "no merge" do
    assert MergeSimulation.merge_list([2, 1, 0]) == {[2, 1, 0], :no}
  end

  ## Testing low endian merge

  test "center low endian merge" do
    assert MergeSimulation.merge_list([4, 4, 3, 3, 2, 1], :low) == {[4, 4, 4, 2, 1], :yes}
  end

  test "left low endian merge" do
    assert MergeSimulation.merge_list([3, 3, 2, 1, 1], :low) == {[3, 3, 2, 2], :yes}
  end

  test "right low endian merge" do
    assert MergeSimulation.merge_list([2, 2, 1, 0, 0], :low) == {[2, 2, 1, 1], :yes}
  end

  test "no low endian merge" do
    assert MergeSimulation.merge_list([4, 3, 2, 1, 0], :low) == {[4, 3, 2, 1, 0], :no}
  end
end
