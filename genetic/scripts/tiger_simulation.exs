defmodule TigerSimulation do
  @behaviour Problem

  alias Types.Chromosome

  @impl true
  def genotype() do
    genes = for _ <- 1..8, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 8}
  end

  @impl true
  def fitness_function(chromosome) do
    tropic_scores = [0.0, 3.0, 2.0, 1.0, 0.5, 1.0, -1.0, 0.0]
    tundra_scores = [1.0, 3.0, -2.0, -1.0, 0.5, 2.0, 1.0, 0.0]

    traits = chromosome.genes

    traits
    |> Enum.zip(tropic_scores)
    |> Enum.map(fn {trait, score} -> trait * score end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(_population, generation), do: generation == 1000
end

solution =
  Genetic.run(TigerSimulation,
    population_size: 20,
    selection_rate: 0.8,
    mutation_rate: 0.1
  )

IO.puts("Found solution")
IO.inspect(solution)

{_, zero_gen_stats} = Utilities.Statistics.lookup(0)
{_, fivehundred_gen_stats} = Utilities.Statistics.lookup(500)
{_, onethousand_gen_stats} = Utilities.Statistics.lookup(1000)

IO.write("""
0th: #{zero_gen_stats.mean_fitness}
500th: #{fivehundred_gen_stats.mean_fitness}
1000th: #{onethousand_gen_stats.mean_fitness}
""")
