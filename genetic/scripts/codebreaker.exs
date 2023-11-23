defmodule Codebreaker do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype() do
    genes = for _ <- 1..64, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 64}
  end

  @impl true
  def fitness_function(chromosome) do
    target = "ILoveGeneticAlgorithms"
    encrypted = ~c"LIjs`B`k`qlfDibjwlqmhv"

    cipher = fn word, key -> Enum.map(word, &rem(Bitwise.bxor(&1, key), 32768)) end

    key =
      chromosome.genes
      |> Enum.map(&Integer.to_string(&1))
      |> Enum.join("")
      |> String.to_integer(2)

    guess = List.to_string(cipher.(encrypted, key))
    String.jaro_distance(target, guess)
  end

  @impl true
  def terminate?(population, _generation, _temperature) do
    Enum.max_by(population, &Codebreaker.fitness_function/1).fitness == 1
  end
end

solution = Genetic.run(Codebreaker, crossover_type: &Toolbox.Crossover.single_point/2)
IO.puts("Found solution")

solution.genes
|> Enum.map(&Integer.to_string(&1))
|> Enum.join("")
|> String.to_integer(2)
|> IO.inspect()
