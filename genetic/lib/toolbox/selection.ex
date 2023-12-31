defmodule Toolbox.Selection do
  def elite(population, n) do
    Enum.take(population, n)
  end

  def random(population, n) do
    Enum.take_random(population, n)
  end

  def tournament(population, n, tournsize) do
    0..(n - 1)
    |> Enum.map(fn _ ->
      population
      |> Enum.take_random(tournsize)
      |> Enum.max_by(& &1.fitness)
    end)
  end

  def tournament_no_duplicates(population, n, tournsize) do
    selected = MapSet.new()
    tournament_helper(population, n, tournsize, selected)
  end

  defp tournament_helper(population, n, tournsize, selected) do
    if MapSet.size(selected) == n do
      MapSet.to_list(selected)
    else
      chosen =
        population
        |> Enum.take_random(tournsize)
        |> Enum.max_by(& &1.fitness)

      tournament_helper(population, n, tournsize, MapSet.put(selected, chosen))
    end
  end

  def roulette(population, n) do
    sum_fitness =
      population
      |> Enum.map(& &1.fitness)
      |> Enum.sum()

    0..(n - 1)
    |> Enum.map(fn _ ->
      u = :rand.uniform() * sum_fitness

      population
      |> Enum.reduce_while(0, fn x, sum ->
        if x.fitness + sum > u do
          {:halt, x}
        else
          {:cont, x.fitness + sum}
        end
      end)
    end)
  end
end
