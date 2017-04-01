defmodule Listus.UserControllerTest do
  use Listus.ConnCase
  alias Listus.User

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user", %{conn: conn} do
    conn = post conn, user_path(conn, :create)
    assert %{"id" => id, "uuid" => uuid} = json_response(conn, 201)
    assert some(user) = User.find_by_uuid(uuid)
    assert user.id == id
  end
end
