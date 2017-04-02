defmodule Listus.Item do
  use Listus.Web, :model
  alias Listus.Item

  defstruct id: nil, name: "", qty: 1, check: false, pos: nil
  @types %{name: :string, qty: :integer, check: :boolean, pos: :integer}

  def changeset(s, params \\ %{}) do
    {Map.from_struct(s) |> Map.drop([:id]), @types}
    |> cast(params, Map.keys(@types))
    |> validate_required(:name)
    |> validate_number(:qty, greater_than: 0)
  end

  def create(list, params) do
    changeset = changeset(%Item{}, params)
    if changeset.valid? do
      """
        MATCH (l) WHERE ID(l) = {lid}
        MERGE (i:Item {iname: toLower({name})})
          ON CREATE SET i.name = {name}
        MERGE (l)-[r:CONTAINS]->(i)
        ON CREATE SET r += {params}
        RETURN r
      """
      |> query(%{params: changeset.changes, lid: list.id, name: params[:name]})
      |> decode_ok(r: __MODULE__)
    else
      error(changeset)
    end
  end

  def all(list) do
    """
      MATCH (l)-[r:CONTAINS]->(:Item)
      WHERE ID(l) = {lid}
      RETURN r ORDER BY r.pos ASC
    """
    |> query(%{lid: list.id})
    |> decode(r: __MODULE__)
  end

  def find(list, item_id) do
    """
      MATCH (l)-[r:CONTAINS]->(:Item)
      WHERE ID(l) = {lid} AND ID(r) = {iid}
      RETURN r
    """
    |> query(%{lid: list.id, iid: item_id})
    |> decode_some(r: __MODULE__)
  end

  def update(item, params) do
    changeset = changeset(item, Map.drop(params, [:name, "name"])) # Meh... atoms are not strings, yeah
    if changeset.valid? do
      """
        MATCH (:List)-[r:CONTAINS]->(:Item)
        WHERE ID(r) = {rid}
        SET r += {params}
        RETURN r
      """
      |> query(%{params: changeset.changes, rid: item.id})
      |> decode_ok(r: __MODULE__)
    else
      error(changeset)
    end
  end

  def delete(item) do
    """
      MATCH (:List)-[r:CONTAINS]->(:Item)
      WHERE ID(r) = {rid}
      DETACH DELETE r
    """
    |> query(%{rid: item.id}) |> ok
  end
end
