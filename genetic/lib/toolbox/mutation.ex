defmodule Toolbox.Mutation do
  alias Types.Chromosome

  def flip(chromosome, p) do
    genes =
      chromosome.genes
      |> Enum.map(fn g ->
        if :rand.uniform() < p do
          Bitwise.bxor(g, 1)
        else
          g
        end
      end)

    %Chromosome{chromosome | genes: genes}
  end

  def flip(chromosome) do
    genes =
      chromosome.genes
      |> Enum.map(&Bitwise.bxor(&1, 1))

    %Chromosome{chromosome | genes: genes}
  end

  def scramble(chromosome) do
    genes =
      chromosome
      |> Enum.shuffle()

    %Chromosome{chromosome | genes: genes}
  end

  def scramble(chromosome, n) do
    start = :rand.uniform(n - 1)

    {lo, hi} =
      if start + n >= chromosome.size do
        {start - n, start}
      else
        {start, start + n}
      end

    head = Enum.slice(chromosome.genes, 0, lo)
    mid = Enum.slice(chromosome.genes, lo, hi)
    tail = Enum.slice(chromosome.genes, hi, chromosome.genes)

    %Chromosome{genes: head ++ Enum.shuffle(mid) ++ tail, size: chromosome.size}
  end

  def gaussian(chromosome) do
    mu = Enum.sum(chromosome.genes) / length(chromosome.genes)

    sigma =
      chromosome.genes
      |> Enum.map(fn x -> (mu - x) * (mu - x) end)
      |> Enum.sum()
      |> Kernel./(length(chromosome.genes))

    genes =
      chromosome.genes
      |> Enum.map(fn _ ->
        :rand.normal(mu, sigma)
      end)

    %Chromosome{chromosome | genes: genes}
  end
end
