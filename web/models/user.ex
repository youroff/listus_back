defmodule Listus.User do
  use Listus.Web, :model
  import Neo4j
  alias Listus.User

  defstruct id: nil, uuid: "", labels: []

  def create do
    query("CREATE (u:User {uuid: {uuid}}) RETURN u", %{uuid: UUID.uuid1()})
    |> decode(u: __MODULE__)
  end

  def find_by_uuid(uuid) do
    query("MATCH (u:User {uuid: {uuid}}) RETURN u", %{uuid: uuid})
    |> decode(u: __MODULE__)
  end
end
