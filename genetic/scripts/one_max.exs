defmodule OneMax do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype() do
    genes = for _ <- 1..42, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 42}
  end

  @impl true
  def fitness_function(chromosome) do
    Enum.sum(chromosome.genes)
  end

  @impl true
  def terminate?(population, generation, temperature), do: generation == 100
end

solution = Genetic.run(OneMax)
IO.puts("Found solution")
IO.inspect(solution)
