defmodule Validator do
  defmacro do_validate(value, :num) do
    quote do
      value = unquote(value)

      {sign, num} =
        case value do
          {sign, _, [num]} -> {sign, num}
          num -> {:+, num}
        end

      if sign == :- do
        {:error,
         "Inappropriate first argument! Expected value greater than zero but got #{sign}#{inspect(num)}"}
      else
        {:ok, value}
      end
    end
  end

  defmacro do_validate(value, :endian) do
    quote do
      value = unquote(value)

      if not (value == :high or value == :low) do
        {:error,
         "Inappropriate second argument! Expected :high or :low but got #{inspect(value)}"}
      else
        {:ok, value}
      end
    end
  end

  defmacro do_validate(value, :inspect) do
    quote do
      value = unquote(value)

      if not (value == :yes or value == :no) do
        {:error, "Inappropriate third argument! Expected :yes or :no but got #{inspect(value)}"}
      end
    end
  end

  defmacro validate(num, endian) do
    case do_validate(num, :num) do
      {:ok, _} ->
        case do_validate(endian, :endian) do
          {:ok, _} -> {:ok, :empty}
          {:error, msg} -> {:error, msg}
        end

      {:error, msg} ->
        {:error, msg}
    end
  end

  defmacro validate(num, endian, inspect) do
    do_validate(num, :num)
    do_validate(endian, :endian)
    do_validate(inspect, :inspect)
  end
end
