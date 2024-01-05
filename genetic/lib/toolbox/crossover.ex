defmodule Toolbox.Crossover do
  alias Types.Chromosome

  def order_one_crossover(p1, p2) do
    # Order-one crossover, sometimes called “Davis order” crossover, is a crossover
    # strategy on ordered lists or permutations. Order-one crossover is part of a
    # unique set of crossover strategies that will preserve the integrity of a permutation
    # solution.
    # This wont work well for NON permuatation list as size of genes will no keep
    # same size.
    size = p1.size - 1

    {from, to} =
      [:rand.uniform(size), :rand.uniform(size)]
      |> Enum.sort()
      |> List.to_tuple()

    slice1 = Enum.slice(p1.genes, from..to)
    {head1, tail1} = (p2.genes -- slice1) |> Enum.split(from)

    slice2 = Enum.slice(p2.genes, from..to)
    {head2, tail2} = (p1.genes -- slice2) |> Enum.split(from)

    {
      %Chromosome{p1 | genes: head1 ++ slice1 ++ tail1, size: p1.size},
      %Chromosome{p2 | genes: head2 ++ slice2 ++ tail2, size: p1.size}
    }
  end

  def single_point(p1, p2) do
    cx_point = :rand.uniform(length(p1.genes))
    {h1, t1} = Enum.split(p1.genes, cx_point)
    {h2, t2} = Enum.split(p2.genes, cx_point)
    {c1, c2} = {h1 ++ t2, h2 ++ t1}
    {%Chromosome{p1 | genes: c1}, %Chromosome{p2 | genes: c2}}
  end

  def uniform(p1, p2, rate) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        if :rand.uniform() < rate do
          {y, x}
        else
          {x, y}
        end
      end)
      |> Enum.unzip()

    {%Chromosome{genes: c1, size: length(c1)}, %Chromosome{genes: c2, size: length(c2)}}
  end

  def whole_arithmetic(p1, p2, alpha) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(fn {x, y} ->
        {
          x * alpha + y * (1 - alpha),
          x * (1 - alpha) + y * alpha
        }
      end)
      |> Enum.unzip()

    {%Chromosome{genes: c1, size: length(c1)}, %Chromosome{genes: c2, size: length(c2)}}
  end
end
