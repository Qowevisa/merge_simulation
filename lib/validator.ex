defmodule Validator do
  @spec __do_validate__(any, :endian | :inspect | :num) ::
          {:error, <<_::64, _::_*8>>} | {:ok, any}
  def __do_validate__(value, :num) do
    if value < 0 do
      {:error,
       "Inappropriate first argument! Expected value greater than zero but got #{inspect(value)}"}
    else
      {:ok, value}
    end
  end

  def __do_validate__(value, :endian) do
    if not (value == :high or value == :low) do
      {:error, "Inappropriate second argument! Expected :high or :low but got #{inspect(value)}"}
    else
      {:ok, value}
    end
  end

  def __do_validate__(value, :inspect) do
    if not (value == :yes or value == :no) do
      {:error, "Inappropriate third argument! Expected :yes or :no but got #{inspect(value)}"}
    else
      {:ok, value}
    end
  end

  @spec __define__(integer(), atom()) :: {:error, <<_::64, _::_*8>>} | {:ok, :empty}
  def __define__(num, endian) do
    case __do_validate__(num, :num) do
      {:ok, _} ->
        case __do_validate__(endian, :endian) do
          {:ok, _} -> {:ok, :empty}
          {:error, msg} -> {:error, msg}
        end

      {:error, msg} ->
        {:error, msg}
    end
  end

  @spec __define__(integer(), atom(), atom()) :: {:error, <<_::64, _::_*8>>} | {:ok, :empty}
  def __define__(num, endian, inspect) do
    case __do_validate__(num, :num) do
      {:ok, _} ->
        case __do_validate__(endian, :endian) do
          {:ok, _} ->
            case __do_validate__(inspect, :inspect) do
              {:ok, _} -> {:ok, :empty}
              {:error, msg} -> {:error, msg}
            end

          {:error, msg} ->
            {:error, msg}
        end

      {:error, msg} ->
        {:error, msg}
    end
  end

  defmacro validate(num, endian) do
    quote do
      Validator.__define__(unquote(num), unquote(endian))
    end
  end

  defmacro validate(num, endian, inspect) do
    quote do
      Validator.__define__(unquote(num), unquote(endian), unquote(inspect))
    end
  end
end
