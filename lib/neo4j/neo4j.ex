defmodule Neo4j do
  import MonEx.Result

  def query(q, p) do
    conn = Bolt.Sips.conn
    Bolt.Sips.query(conn, q, p)
  end

  def decode(result, opts \\ [])
  def decode(ok(result), opts) do
    Enum.flat_map(result, &decode_one(&1, opts))
    |> Enum.filter(& &1)
    |> convert()
  end
  def decode(err, opts), do: err

  def convert([]), do: error(:empty)
  def convert([single]), do: ok(single)
  def convert(many), do: ok(many)

  def decode_one(hash, opts) do
    Enum.map opts, fn {key, model} ->
      hash[Atom.to_string(key)]
      |> populate_one(model)
    end
  end

  defp populate_one(%Bolt.Sips.Types.Node{id: id, labels: labels, properties: props}, model) do
    struct(model, Map.merge(atomize(props), %{id: id, labels: labels}))
  end
  defp populate_one(_, _), do: nil

  defp atomize(hash) do
    Map.new(hash, fn {k, v} -> {String.to_atom(k), v} end)
  end
end
