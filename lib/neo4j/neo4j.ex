defmodule Neo4j do
  import MonEx.{Result, Option}

  def query(q, p) do
    conn = Bolt.Sips.conn
    Bolt.Sips.query!(conn, q, p)
  end

  def decode_some(result, opts \\ []) do
    case decode(result, opts) do
      [item | _] -> some(item)
      _ -> none()
    end
  end

  def decode_ok(result, opts \\ []) do
    case decode(result, opts) do
      [item | _] -> ok(item)
      _ -> raise "Destructive operation didn't return a result"
    end
  end

  def decode(result, opts \\ []) do
    Enum.flat_map(result, &decode_item(&1, opts))
    |> Enum.filter(& &1)
  end

  def decode_item(hash, opts) do
    Enum.map opts, fn {key, model} ->
      hash[Atom.to_string(key)]
      |> populate(model)
    end
  end

  defp populate(%Bolt.Sips.Types.Node{id: id, labels: labels, properties: props}, model) do
    struct(model, Map.merge(atomize(props), %{id: id, labels: labels}))
  end

  defp populate(%Bolt.Sips.Types.Relationship{id: id, properties: props}, model) do
    struct(model, Map.merge(atomize(props), %{id: id}))
  end

  defp populate(_, _), do: nil

  defp atomize(hash) do
    Map.new(hash, fn {k, v} -> {String.to_atom(k), v} end)
  end
end
