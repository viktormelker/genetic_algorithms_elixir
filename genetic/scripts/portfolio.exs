defmodule Portfolio do
  @behaviour Problem
  alias Types.Chromosome

  @target_fitness 180

  @impl true
  def genotype() do
    genes =
      for _ <- 1..10, do: {:rand.uniform(10), :rand.uniform(10)}

    %Chromosome{genes: genes, size: 10}
  end

  @impl true
  def fitness_function(chromosome) do
    chromosome.genes
    |> Enum.map(fn {roi, risk} -> 2 * roi - risk end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(population, _generation) do
    max_value = Enum.max_by(population, &Portfolio.fitness_function/1).fitness
    max_value > @target_fitness
  end
end

solution = Genetic.run(Portfolio)
IO.puts("Found solution")
IO.inspect(solution)
