defmodule FizzBuzz do
  @moduledoc """
  Documentation for FizzBuzz.
  """

  def play_naive(n) do
    1..n
    |> Enum.map(fn
      i ->
        cond do
          divisible(i, 3 * 5) ->
            "Fizz Buzz"

          divisible(i, 3) ->
            "Fizz"

          divisible(i, 5) ->
            "Buzz"

          true ->
            i
        end
    end)
  end

  defp divisible(dividend, divisor), do: rem(dividend, divisor) == 0

  # -----------------

  def play_func(n) do
    rules = [{3 * 5, "Fizz Buzz"}, {3, "Fizz"}, {5, "Buzz"}]
    1..n |> Enum.map(&execute1(&1, rules))
  end

  defp execute1(i, rules) do
    Enum.reduce(rules, i, fn
      _, acc when is_bitstring(acc) -> acc
      {divisor, word}, _ when rem(i, divisor) == 0 -> word
      _, acc -> acc
    end)
  end

  # ---------------------------
  # 1. more abstraction of rules
  # 2. lazy generation

  def play_polish(n) do
    rules = [Fizz: &divisible(&1, 3), Buzz: &divisible(&1, 5), Zazz: &(&1 < 10)]
    1..n |> Stream.map(&execute2(&1, rules)) |> Enum.map(& &1)
  end

  defp execute2(i, rules) do
    Enum.reduce(rules, [], fn {word, rule}, acc ->
      if rule.(i), do: [word | acc], else: acc
    end)
    |> Enum.reverse()
    |> Enum.map(&to_string/1)
    |> (fn
          [] -> i
          words -> Enum.join(words, " ")
        end).()
  end
end
