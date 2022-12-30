defmodule MergeSimulation do
  @moduledoc """
  Documentation for `MergeSimulation`.
  """

  @doc """
  Simulates `num` iterations. Simulation can be high or low.
  Set second argument as :high atom and :low atom for low iteration respectively.
  Can be inspected if passed `:yes` atom as third argument
  """
  @spec iterate(integer, atom, atom) :: {:error, <<_::64, _::_*8>>} | {:ok, list(integer)}
  def iterate(num, endian \\ :high, inspect \\ :no) do
    require Validator

    case Validator.validate(num, endian, inspect) do
      {:ok, _} -> {:ok, do_iterate(num, [], endian, inspect)}
      {:error, msg} -> {:error, msg}
    end
  end

  @spec do_iterate(integer, list, atom, atom) :: list(integer)
  defp do_iterate(num, list, endian, inspect) do
    {new_list, was_merged} = if length(list) == 0,
      do: {list ++ [0], :no},
      else: merge_list(list ++ [0], endian)
    if inspect == :yes, do: IO.puts('List in iteration: #{inspect(new_list)} #{was_merged}')

    if num == 1 do
      new_list
    else
      do_iterate(num - 1, new_list, endian, inspect)
    end
  end

  @doc """
  Merging list is done with converting two integers
  with same number into one that is bigger by 1 in `endian` order.
  For example if function will see two [0, 0] it will transform it into [1]
  Uses private function with tail-end recursion
  Returns turple that contains one iteration for high or low order merging and atom
  that signals if it was merged or not.

  ## Examples

      eix> MergeSimulation.merge_list([2, 1, 0, 0], :low)
      [2, 1, 1]
      eix> MergeSimulation.merge_list([3, 3, 2, 1, 1, 0], :low)
      [3, 3, 2, 2, 0]
      eix> MergeSimulation.merge_list([4, 2, 1, 1, 0, 0])
      [4, 2, 2, 0, 0]
      eix> MergeSimulation.merge_list([4, 2, 2, 0, 0], :low)
      [4, 2, 2, 1]
      eix> MergeSimulation.merge_list([4, 3, 0, 0], :high)
      [4, 3, 1]

  """
  @spec merge_list(list(integer), :high | :low) :: {list(integer), :yes | :no}
  def merge_list(list, endian \\ :high) do
    do_merge_list(list, [], endian)
  end

  defp do_merge_list(list, acc, :high) do
    [f, s] ++ xs = list

    if f == s do
      {acc ++ [f + 1] ++ xs, :yes}
    else
      if length(list) == 2,
        do: {acc ++ list, :no},
        else: do_merge_list([s] ++ xs, acc ++ [f], :high)
    end
  end

  defp do_merge_list(list, acc, :low) do
    [f, s] ++ xs = Enum.reverse(list)

    if f == s do
      {Enum.reverse(xs) ++ [f + 1] ++ acc, :yes}
    else
      if length(list) == 2,
        do: {list ++ acc, :no},
        else: do_merge_list(Enum.reverse(xs) ++ [s], [f] ++ acc, :low)
    end
  end
end
