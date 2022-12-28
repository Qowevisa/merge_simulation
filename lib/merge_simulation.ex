defmodule MergeSimulation do
  @moduledoc """
  Documentation for `MergeSimulation`.
  """

  @doc """
  Simulates `num` iterations. Simulation can be high or low.
  Set second argument as :high atom and :low atom for low iteration respectively.
  """
  @spec iterate(pos_integer, atom) :: list
  def iterate(num, :high) do
    do_iterate(num, [], :high, :no)
  end

  def iterate(num, :low) do
    do_iterate(num, [], :low, :no)
  end

  def iterate(num, endian) do
    if num < 0 do
      raise("Inappropriate first argument! Expected value greater than zero but got #{inspect endian}")
    end
    if not (endian == :high or endian == :low) do
      raise("Inappropriate second argument! Expected :high or :low but got #{inspect endian}")
    end
  end

  @doc """
  Simulates `num` iterations. Simulation can be high or low.
  Set second argument as :high atom and :low atom for low iteration respectively.
  Can be inspected if passed `:yes` atom as third argument
  """
  def iterate(num, :high, :yes) do
    do_iterate(num, [], :high, :yes)
  end

  def iterate(num, :low, :yes) do
    if num < 0 do
      raise("Inappropriate first argument! Expected value greater than zero but got #{inspect num}")
    end
    do_iterate(num, [], :low, :yes)
  end

  def iterate(num, endian, inspect) do
    if num < 0 do
      raise("Inappropriate first argument! Expected value greater than zero but got #{inspect num}")
    end
    if not (endian == :high or endian == :low) do
      raise("Inappropriate second argument! Expected :high or :low but got #{inspect endian}")
    end
    if not (inspect == :yes or endian == :no) do
      raise("Inappropriate third argument! Expected :yes or :no but got #{inspect endian}")
    end
  end

  @spec do_iterate(integer, list, atom, atom) :: list
  defp do_iterate(num, list, endian, inspect) do
    new_list = if length(list) == 0, do: list ++ [0], else: merge_list(list ++ [0], endian)
    if inspect == :yes, do: IO.inspect new_list, label: 'List in iteration:'
    if num == 1 do
      new_list
    else
      do_iterate(num - 1, new_list, endian, inspect)
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
