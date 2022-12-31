defmodule MergeSimulation do
  @moduledoc """
  Documentation for `MergeSimulation`.
  """

  @spec compare(integer) :: {:ok}
  def compare(num) do
    %{ind_list: ind_list, comp_list: comp_list, merge_list: merge_list} =
      do_compare(num, [], [], [], [], [])

    {:ok, file} = File.open("data_1", [:write])
    IO.puts(file, "#{inspect(ind_list, limit: :infinity)}")
    IO.puts(file, "#{inspect(comp_list, limit: :infinity)}")
    IO.puts(file, "#{inspect(merge_list, limit: :infinity)}")
    {:ok}
  end

  defp do_compare(num, low_list, high_list, ind_list, comp_list, merge_list) do
    # will be [1..]
    ind_list = ind_list ++ [length(ind_list) + 1]
    %{list: low_list, merged: low_merged} = do_iterate(1, low_list, :low, :no)
    %{list: high_list, merged: high_merged} = do_iterate(1, high_list, :high, :no)

    if num == 1,
      do: %{
        ind_list: ind_list,
        comp_list: comp_list ++ [boolean_to_integer(low_list == high_list)],
        merge_list: merge_list ++ [boolean_to_integer(low_merged == high_merged)]
      },
      else:
        do_compare(
          num - 1,
          low_list,
          high_list,
          ind_list,
          comp_list ++ [boolean_to_integer(low_list == high_list)],
          merge_list ++ [boolean_to_integer(low_merged == high_merged)]
        )
  end

  def compare_bar(num) do
    do_compare_bar(num, [], [], 1, false, 0, [], [])
  end

  defp do_compare_bar(
         num,
         low_list,
         high_list,
         iteration,
         comp_status,
         data_acc,
         ind_list,
         data_list
       ) do
    %{list: low_list, merged: _} = do_iterate(1, low_list, :low, :no)
    %{list: high_list, merged: _} = do_iterate(1, high_list, :high, :no)

    if num == 1 do
      %{
        ind_list: Enum.take(ind_list, length(ind_list) - 1),
        data_list: Enum.take(data_list, -(length(data_list) - 1))
      }
    else
      if do_we_switch?(low_list, high_list, comp_status) do
        do_compare_bar(
          num - 1,
          low_list,
          high_list,
          iteration + 1,
          low_list == high_list,
          1,
          ind_list ++ [iteration],
          data_list ++ [data_acc]
        )
      else
        do_compare_bar(
          num - 1,
          low_list,
          high_list,
          iteration + 1,
          comp_status,
          data_acc + 1,
          ind_list,
          data_list
        )
      end
    end
  end

  defp do_we_switch?(low_list, high_list, comp_status) do
    if Bitwise.bxor(boolean_to_integer(low_list == high_list), boolean_to_integer(comp_status)) ==
         1 do
      true
    else
      false
    end
  end

  defp boolean_to_integer(bool) do
    if bool, do: 1, else: 0
  end

  @doc """
  Simulates `num` iterations. Simulation can be high or low.
  Set second argument as :high atom and :low atom for low iteration respectively.
  Can be inspected if passed `:yes` atom as third argument
  """
  @spec iterate(integer, atom, atom) :: {:error, <<_::64, _::_*8>>} | {:ok, list(integer)}
  def iterate(num, endian \\ :high, inspect \\ :no) do
    require Validator

    case Validator.validate(num, endian, inspect) do
      {:ok, _} -> {:ok, do_iterate(num, [], endian, inspect)[:list]}
      {:error, msg} -> {:error, msg}
    end
  end

  # Merged atom is used when num is 1 and we need to check was on that iteration list merged or not
  @spec do_iterate(integer, list, :high | :low, :yes | :no) :: %{
          list: list(integer),
          merged: :yes | :no
        }
  defp do_iterate(num, list, endian, inspect) do
    {new_list, was_merged} =
      if length(list) == 0,
        do: {list ++ [0], :no},
        else: merge_list(list ++ [0], endian)

    if inspect == :yes, do: IO.puts('List in iteration: #{inspect(new_list)} #{was_merged}')

    if num == 1,
      do: %{list: new_list, merged: was_merged},
      else: do_iterate(num - 1, new_list, endian, inspect)
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
