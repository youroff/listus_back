defmodule Listus.User do
  use Listus.Web, :model
  alias Listus.User

  defstruct id: nil, uuid: ""

  def create do
    query("CREATE (u:User {uuid: {uuid}}) RETURN u", %{uuid: UUID.uuid1()})
    |> decode_ok(u: __MODULE__)
  end

  def find_by_uuid(uuid) do
    query("MATCH (u:User {uuid: {uuid}}) RETURN u", %{uuid: uuid})
    |> decode_some(u: __MODULE__)
  end
end
