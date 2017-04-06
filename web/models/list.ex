defmodule Listus.List do
  use Listus.Web, :model
  alias Listus.List

  defstruct id: nil, name: ""
  @types %{name: :string}

  def changeset(s, params \\ %{}) do
    {Map.from_struct(s) |> Map.drop([:id]), @types}
    |> cast(params, Map.keys(@types))
    |> validate_required(:name)
  end

  def create(user, params) do
    changeset = changeset(%List{}, params)
    if changeset.valid? do
      """
        MATCH (u:User) WHERE ID(u) = {uid}
        CREATE (u)-[:OWNS]->(l:List {params})
        RETURN l
      """
      |> query(%{params: changeset.changes, uid: user.id})
      |> decode_ok(l: __MODULE__)
    else
      error(changeset)
    end
  end

  def all(user) do
    """
      MATCH (u:User)-[r:OWNS]->(l:List) WHERE ID(u) = {uid}
      RETURN l ORDER BY l.name ASC
    """
    |> query(%{uid: user.id})
    |> decode(l: __MODULE__)
  end

  def find(user, list_id) do
    """
      MATCH (u:User)-[r:OWNS]->(l:List)
      WHERE ID(u) = {uid} AND ID(l) = {lid}
      RETURN l
    """
    |> query(%{uid: user.id, lid: list_id})
    |> decode_some(l: __MODULE__)
  end

  def update(list, params) do
    changeset = changeset(list, params)
    if changeset.valid? do
      """
        MATCH (l:List) WHERE ID(l) = {lid}
        SET l += {params}
        RETURN l
      """
      |> query(%{params: changeset.changes, lid: list.id})
      |> decode_ok(l: __MODULE__)
    else
      error(changeset)
    end
  end

  def delete(list) do
    """
      MATCH (l:List) WHERE ID(l) = {lid}
      DETACH DELETE l
    """
    |> query(%{lid: list.id}) |> ok
  end
end
