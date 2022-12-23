defmodule MergeSimulation do
  @moduledoc """
  Documentation for `MergeSimulation`.
  """

  @doc """
  Simulates `num` high iterations. Can be inspected if passed `:yes` atom as second argument
  """
  def high_iterate(num) do
    do_high_iterate(num, [], :no)
  end

  def high_iterate(num, inspect) do
    do_high_iterate(num, [], inspect)
  end

  @spec do_high_iterate(integer, list, atom) :: list
  defp do_high_iterate(num, list, inspect) do
    new_list = if length(list) == 0, do: list ++ [0], else: merge_list(list ++ [0], :high)
    if inspect == :yes, do: IO.inspect new_list, label: 'List in iteration'
    if num == 1 do
      new_list
    else
      do_high_iterate(num - 1, new_list, inspect)
    end
  end

  @doc """
  Merging list is done with converting two integers
  with same number into one that is bigger by 1 in high order.
  For example if function will see two [0, 0] it will transform it into [1]
  Uses private function with tail-end recursion
  Returns one iteration for high order merging.

  ## Examples

      eix> MergeSimulation.merge_list([2, 1, 0, 0])
      [2, 1, 1]
      eix> MergeSimulation.merge_list([3, 2, 1, 0])
      [3, 2, 1, 0]

  """
  def merge_list(list, endian) do
    if endian == :high do
      do_merge_list(list, [])
    else
      do_merge_list_little_endian(list, [])
    end
  end

  def merge_list(list) do
    do_merge_list(list, [])
  end

  defp do_merge_list(list, acc) do
    [f, s] ++ xs = list
    if f == s do
      acc ++ [f + 1] ++ xs
    else
      if length(list) == 2, do: acc ++ list, else:
      do_merge_list([s] ++ xs, acc ++ [f])
    end
  end

  defp do_merge_list_little_endian(list, acc) do
    [f, s] ++ xs = Enum.reverse(list)
    if f == s do
      Enum.reverse(xs) ++ [f + 1] ++ acc
    else
      if length(list) == 2, do: list ++ acc, else:
      do_merge_list_little_endian(Enum.reverse(xs) ++ [s], [f] ++ acc)
    end
  end
end
